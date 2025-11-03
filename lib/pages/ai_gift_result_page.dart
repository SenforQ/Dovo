import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiGiftResultPage extends StatefulWidget {
  final Set<String> occasions;
  final String? relationship;
  final double budget;
  final String details;

  const AiGiftResultPage({
    super.key,
    required this.occasions,
    required this.relationship,
    required this.budget,
    required this.details,
  });

  @override
  State<AiGiftResultPage> createState() => _AiGiftResultPageState();
}

class _AiGiftResultPageState extends State<AiGiftResultPage> {
  bool _loading = true;
  String _aiResponse = '';
  bool? _isSatisfied;

  @override
  void initState() {
    super.initState();
    _generateGiftRecommendation();
  }

  Future<void> _generateGiftRecommendation() async {
    setState(() {
      _loading = true;
    });

    try {
      final occasionsText = widget.occasions.join(', ');
      final prompt = '''
Based on the following gift request information, provide a personalized gift recommendation in English:

Occasion(s): $occasionsText
Relationship: ${widget.relationship ?? 'Unknown'}
Budget: \$${widget.budget.toInt()}
Details: ${widget.details}

Please provide:
1. A friendly introduction message
2. A gift idea with:
   - Recipient name (if mentioned in details, otherwise use a placeholder name)
   - Occasion
   - Gift name
   - Gift description explaining why this gift is suitable

Format your response in a clear, friendly manner as if you're an AI gift assistant helping the user find the perfect gift.
''';

      final response = await http.post(
        Uri.parse('https://open.bigmodel.cn/api/paas/v4/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer d855db6002fa4f01b31b6ee40503a94f.ruLsXOqSmbjCONhl',
        },
        body: jsonEncode({
          'model': 'glm-4-flash',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an AI gift assistant that helps users find perfect gifts. Respond in English only.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        if (mounted) {
          setState(() {
            _aiResponse = content;
            _loading = false;
          });
        }
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error generating gift recommendation: $e');
      if (mounted) {
        setState(() {
          _aiResponse = 'Based on the content you submitted, I found the following content for you. Let\'s take a look and see if this gift meets your expectations~\n\n**Gift Idea Taken Directly from a Friend\'s Wishlist**\n\n• Recipient: 👫 Jamie\n• Occasion: ${widget.occasions.join(' · ')}\n• Gift Name: Noise-Canceling Bluetooth Headphones\n• Gift Description: Based on your preferences and budget of \$${widget.budget.toInt()}, this gift is perfect for ${widget.relationship ?? 'your recipient'}. ${widget.details}';
          _loading = false;
        });
      }
    }
  }

  Future<void> _onSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing saved gifts
      final savedGiftsJson = prefs.getStringList('saved_gifts') ?? [];
      final savedGifts = savedGiftsJson.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
      
      // Create new gift entry
      final newGift = {
        'occasions': widget.occasions.toList(),
        'relationship': widget.relationship,
        'budget': widget.budget,
        'details': widget.details,
        'aiResponse': _aiResponse,
        'isSatisfied': _isSatisfied,
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      // Add to saved gifts
      savedGifts.add(newGift);
      
      // Save back to SharedPreferences
      final updatedJson = savedGifts.map((gift) => jsonEncode(gift)).toList();
      await prefs.setStringList('saved_gifts', updatedJson);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error saving gift: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save'),
            duration: Duration(seconds: 2),
          ),
        );
      }
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
        title: Image.asset(
          'assets/community_title.webp',
          width: 245,
          height: 30,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
        child: Column(
          children: [
            SizedBox(height: topSafe + 55),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _aiResponse,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            // Satisfy / Not satisfied buttons - Fixed at bottom (only show when response is ready)
            if (!_loading && _aiResponse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSatisfied = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thanks for your feedback'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _isSatisfied == true
                              ? const Color(0xFFE8D5FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isSatisfied == true
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '😊',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Satisfy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSatisfied = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thanks for your feedback'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _isSatisfied == false
                              ? const Color(0xFFE8D5FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isSatisfied == false
                                ? const Color(0xFF8B5CF6)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '😞',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Not satisfied',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Save button - Fixed at bottom (only show when AI response is ready)
            if (!_loading && _aiResponse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

