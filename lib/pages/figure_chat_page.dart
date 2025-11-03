import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_profile.dart';

class FigureChatPage extends StatefulWidget {
  final Map<String, dynamic> figureData;
  const FigureChatPage({super.key, required this.figureData});

  @override
  State<FigureChatPage> createState() => _FigureChatPageState();
}

class _FigureChatPageState extends State<FigureChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _userAvatarPath;
  final UserProfileManager _userProfileManager = UserProfileManager();
  
  String get _figureAvatar => widget.figureData['DovoUserIcon'] as String? ?? 'assets/app_default_headerIcon.webp';

  static const String _apiKey = 'd855db6002fa4f01b31b6ee40503a94f.ruLsXOqSmbjCONhl';
  static const String _apiUrl = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';

  String get _figureNickName => widget.figureData['DovoNickName'] as String? ?? '';

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatKey = 'chat_$_figureNickName';
      final chatJson = prefs.getString(chatKey);
      
      if (chatJson != null) {
        final List<dynamic> messagesData = jsonDecode(chatJson);
        if (mounted) {
          setState(() {
            _messages.clear();
            _messages.addAll(messagesData.map((m) => ChatMessage(
              role: m['role'] as String,
              content: m['content'] as String,
            )).toList());
          });
          _scrollToBottom();
        }
      } else {
        // No chat history, send welcome message
        _sendWelcomeMessage();
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      _sendWelcomeMessage();
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatKey = 'chat_$_figureNickName';
      final messagesData = _messages.map((m) => {
        'role': m.role,
        'content': m.content,
      }).toList();
      await prefs.setString(chatKey, jsonEncode(messagesData));
      
      // Update last message timestamp
      await prefs.setString('chat_last_${_figureNickName}', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error saving chat history: $e');
    }
  }

  Future<void> _loadUserAvatar() async {
    final profile = _userProfileManager.notifier.value;
    if (profile.avatarFileName != null && profile.avatarFileName!.isNotEmpty) {
      final fullPath = await _userProfileManager.buildAvatarFullPath(profile.avatarFileName);
      if (fullPath != null && mounted && File(fullPath).existsSync()) {
        setState(() {
          _userAvatarPath = fullPath;
        });
      }
    }
  }

  void _sendWelcomeMessage() {
    final sayhi = widget.figureData['DovoShowSayhi'] as String? ?? 'Hello! How can I help you?';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _messages.add(ChatMessage(role: 'assistant', content: sayhi));
      });
      await _saveChatHistory();
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: text));
      _messageController.clear();
      _isLoading = true;
    });
    
    await _saveChatHistory();
    _scrollToBottom();

    try {
      // Prepare messages with system prompt to ensure English responses
      final messagesList = [
        {
          'role': 'system',
          'content': 'You are a helpful assistant. Please respond in English only.'
        },
        ..._messages.map((m) => {
              'role': m.role,
              'content': m.content,
            }).toList(),
      ];

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'GLM-4-Flash',
          'messages': messagesList,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiContent = data['choices']?[0]?['message']?['content'] as String? ?? 'Sorry, I could not generate a response.';
        
        setState(() {
          _messages.add(ChatMessage(role: 'assistant', content: aiContent));
          _isLoading = false;
        });
        await _saveChatHistory();
      } else {
        setState(() {
          _messages.add(ChatMessage(
            role: 'assistant',
            content: 'Error: ${response.statusCode}. Please try again.',
          ));
          _isLoading = false;
        });
        await _saveChatHistory();
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          role: 'assistant',
          content: 'Network error. Please check your connection and try again.',
        ));
        _isLoading = false;
      });
      await _saveChatHistory();
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: Image.asset(
              'assets/base_back.webp',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          _figureNickName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Figure avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  _figureAvatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'assets/app_default_headerIcon.webp',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final message = _messages[index];
                    final isUser = message.role == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            // Figure avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  _figureAvatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'assets/app_default_headerIcon.webp',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              constraints: BoxConstraints(maxWidth: size.width * 0.75),
                              decoration: BoxDecoration(
                                color: isUser ? const Color(0xFF2C27B8) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (isUser) ...[
                            const SizedBox(width: 8),
                            // User avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              child: ClipOval(
                                child: _userAvatarPath != null && File(_userAvatarPath!).existsSync()
                                    ? Image.file(
                                        File(_userAvatarPath!),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Image.asset(
                                          'assets/app_default_headerIcon.webp',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/app_default_headerIcon.webp',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFF2C27B8), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFF2C27B8), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFF2C27B8), width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C27B8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});
}

