import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'figure_chat_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> _chatList = [];
  bool _loading = true;
  Map<String, Map<String, dynamic>> _figuresMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    
    try {
      // Load figures data
      final raw = await rootBundle.loadString('assets/figur_detail.json');
      final List<dynamic> figuresList = jsonDecode(raw);
      
      // Create a map for quick lookup by nickname
      for (var figure in figuresList) {
        if (figure is Map<String, dynamic>) {
          final nickName = figure['DovoNickName'] as String? ?? '';
          if (nickName.isNotEmpty) {
            _figuresMap[nickName] = figure;
          }
        }
      }

      // Load chat history from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final List<Map<String, dynamic>> chats = [];

      for (var key in allKeys) {
        if (key.startsWith('chat_') && !key.startsWith('chat_last_')) {
          final nickName = key.replaceFirst('chat_', '');
          
          // Check if we have figure data for this nickname
          if (_figuresMap.containsKey(nickName)) {
            final chatJson = prefs.getString(key);
            if (chatJson != null) {
              try {
                final List<dynamic> messages = jsonDecode(chatJson);
                if (messages.isNotEmpty) {
                  // Get last message
                  final lastMessage = messages.last;
                  final lastMessageContent = lastMessage['content'] as String? ?? '';
                  final lastMessageRole = lastMessage['role'] as String? ?? '';
                  
                  // Get last message timestamp
                  final lastTimeKey = 'chat_last_$nickName';
                  final lastTimeStr = prefs.getString(lastTimeKey);
                  
                  // Get tags from first photo array item
                  final figureData = _figuresMap[nickName]!;
                  final photoArray = figureData['DovoShowPhotoArray'];
                  List<String> tags = [];
                  if (photoArray is List && photoArray.isNotEmpty) {
                    final first = photoArray.first;
                    if (first is Map && first['tags'] is List) {
                      tags = List<String>.from(first['tags']);
                    }
                  }

                  chats.add({
                    'nickName': nickName,
                    'figureData': figureData,
                    'lastMessage': lastMessageContent,
                    'lastMessageRole': lastMessageRole,
                    'lastTime': lastTimeStr,
                    'tags': tags,
                  });
                }
              } catch (e) {
                debugPrint('Error parsing chat for $nickName: $e');
              }
            }
          }
        }
      }

      // Sort by last message time (most recent first)
      chats.sort((a, b) {
        final timeA = a['lastTime'] as String? ?? '';
        final timeB = b['lastTime'] as String? ?? '';
        if (timeA.isEmpty && timeB.isEmpty) return 0;
        if (timeA.isEmpty) return 1;
        if (timeB.isEmpty) return -1;
        return timeB.compareTo(timeA);
      });

      if (mounted) {
        setState(() {
          _chatList = chats;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading chat list: $e');
      if (mounted) {
        setState(() {
          _chatList = [];
          _loading = false;
        });
      }
    }
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Recommend':
        return const Color(0xFFFF6B6B); // Light red
      case 'Holiday':
        return const Color(0xFF4ECDC4); // Light blue
      case 'Anniversary':
        return const Color(0xFFFFB6C1); // Light pink
      case 'Birthday':
        return const Color(0xFFFFB6C1); // Light pink
      default:
        return Colors.grey;
    }
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
        title: const Text(
          'MESSAGE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _chatList.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: _chatList.length,
                      itemBuilder: (context, index) {
                        final chat = _chatList[index];
                        final figureData = chat['figureData'] as Map<String, dynamic>;
                        final nickName = chat['nickName'] as String;
                        final lastMessage = chat['lastMessage'] as String;
                        final lastMessageRole = chat['lastMessageRole'] as String;
                        final tags = chat['tags'] as List<String>;
                        final userIcon = figureData['DovoUserIcon'] as String? ?? 'assets/app_default_headerIcon.webp';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FigureChatPage(figureData: figureData),
                                ),
                              );
                              // Reload data after returning
                              _loadData();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF8B5CF6),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Avatar
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            userIcon,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Image.asset(
                                              'assets/app_default_headerIcon.webp',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Small thumbnail overlay (same avatar)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              userIcon,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Image.asset(
                                                'assets/app_default_headerIcon.webp',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Online status indicator (always green for now)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                            border: Border.fromBorderSide(
                                              BorderSide(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Name, message, and tag
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nickName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          lastMessage,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (tags.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            children: tags.take(1).map((tag) {
                                              return Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getTagColor(tag),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  // Call icon
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8B5CF6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

