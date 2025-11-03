import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  int _selectedIndex = 0; // 0 for planning, 1 for completed
  List<Map<String, dynamic>> _planningItems = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGifts();
  }

  Future<void> _loadSavedGifts() async {
    setState(() {
      _loading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGiftsJson = prefs.getStringList('saved_gifts') ?? [];
      final savedGifts = savedGiftsJson.map((json) {
        try {
          return jsonDecode(json) as Map<String, dynamic>;
        } catch (e) {
          debugPrint('Error parsing gift JSON: $e');
          return <String, dynamic>{};
        }
      }).where((gift) => gift.isNotEmpty).toList();
      
      // Filter based on selected tab
      // Planning: items that are not marked as completed
      // Completed: items marked as completed
      List<Map<String, dynamic>> items;
      if (_selectedIndex == 0) {
        // Planning: show items that are not completed
        items = savedGifts.where((gift) {
          final isCompleted = gift['isCompleted'] as bool? ?? false;
          return !isCompleted;
        }).toList();
      } else {
        // Completed: show items that are completed
        items = savedGifts.where((gift) {
          final isCompleted = gift['isCompleted'] as bool? ?? false;
          return isCompleted;
        }).toList();
      }
      
      if (mounted) {
        setState(() {
          _planningItems = items;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved gifts: $e');
      if (mounted) {
        setState(() {
          _planningItems = [];
          _loading = false;
        });
      }
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadSavedGifts();
  }

  Future<void> _markAsCompleted(Map<String, dynamic> gift) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGiftsJson = prefs.getStringList('saved_gifts') ?? [];
      final savedGifts = savedGiftsJson.map((json) {
        try {
          return jsonDecode(json) as Map<String, dynamic>;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).where((g) => g.isNotEmpty).toList();
      
      // Find and update the gift
      final savedAt = gift['savedAt'] as String?;
      for (var i = 0; i < savedGifts.length; i++) {
        if (savedGifts[i]['savedAt'] == savedAt) {
          savedGifts[i]['isCompleted'] = true;
          break;
        }
      }
      
      // Save back to SharedPreferences
      final updatedJson = savedGifts.map((g) => jsonEncode(g)).toList();
      await prefs.setStringList('saved_gifts', updatedJson);
      
      // Reload data
      await _loadSavedGifts();
    } catch (e) {
      debugPrint('Error marking gift as completed: $e');
    }
  }


  String _formatDate(String? savedAt) {
    if (savedAt == null || savedAt.isEmpty) return '';
    try {
      final date = DateTime.parse(savedAt);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  String _extractDescription(Map<String, dynamic> gift) {
    final aiResponse = gift['aiResponse'] as String? ?? '';
    final details = gift['details'] as String? ?? '';
    
    // Try to extract description from AI response or use details
    if (aiResponse.isNotEmpty) {
      // Extract first meaningful sentence or use a default
      final lines = aiResponse.split('\n');
      for (var line in lines) {
        if (line.trim().isNotEmpty && !line.trim().startsWith('*') && line.length > 20) {
          return line.trim();
        }
      }
    }
    
    return details.isNotEmpty ? details : 'A thoughtful gift recommendation';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final tabBarHeight = bottomSafe + 58;
    
    return Scaffold(
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
            SizedBox(height: topSafe),
            // Buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _onTabChanged(0),
                    child: Image.asset(
                      _selectedIndex == 0
                          ? 'assets/checklist_planning_s.webp'
                          : 'assets/checklist_planning_n.webp',
                      width: 128,
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 23),
                  GestureDetector(
                    onTap: () => _onTabChanged(1),
                    child: Image.asset(
                      _selectedIndex == 1
                          ? 'assets/checklist_completed_s.webp'
                          : 'assets/checklist_completed_n.webp',
                      width: 128,
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // List of items
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _planningItems.isEmpty
                      ? const Center(
                          child: Text(
                            'No items',
                            style: TextStyle(fontSize: 23, color: Colors.white),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Column(
                            children: [
                              ..._planningItems.map((gift) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _PlanningItem(
                                    gift: gift,
                                    date: _formatDate(gift['savedAt'] as String?),
                                    description: _extractDescription(gift),
                                    onDone: () => _markAsCompleted(gift),
                                    showDoneButton: _selectedIndex == 0,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanningItem extends StatelessWidget {
  final Map<String, dynamic> gift;
  final String date;
  final String description;
  final VoidCallback onDone;
  final bool showDoneButton;

  const _PlanningItem({
    required this.gift,
    required this.date,
    required this.description,
    required this.onDone,
    this.showDoneButton = true,
  });

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Tips'),
          content: const Text('Have you completed this Planning? It will be moved to Completed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onDone();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Color(0xFF7300FF)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 298,
      child: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/planning_list_bg.webp',
            width: 335,
            height: 298,
            fit: BoxFit.cover,
          ),
          // Content overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description text below date
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 11,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Done button at bottom (only show in Planning tab)
          if (showDoneButton)
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _showConfirmDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7300FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
