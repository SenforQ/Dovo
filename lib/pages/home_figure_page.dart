import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'figure_chat_page.dart';
import 'figure_video_page.dart';
import 'report_page.dart';
import 'gift_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFigurePage extends StatefulWidget {
  final Map<String, dynamic> figureData;
  const HomeFigurePage({super.key, required this.figureData});

  @override
  State<HomeFigurePage> createState() => _HomeFigurePageState();
}

class _HomeFigurePageState extends State<HomeFigurePage> {

  Future<void> _addBlocked(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final blocked = (prefs.getStringList('blocked_users') ?? const <String>[]).toSet();
    blocked.add(name);
    await prefs.setStringList('blocked_users', blocked.toList());
    if (mounted) {
      // Pop until we reach the home page (main tab page)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _addMuted(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final muted = (prefs.getStringList('muted_users') ?? const <String>[]).toSet();
    muted.add(name);
    await prefs.setStringList('muted_users', muted.toList());
    if (mounted) {
      // Pop until we reach the home page (main tab page)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showMoreActions(String name) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportPage()),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.black)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _addBlocked(name);
            },
            child: const Text('Block', style: TextStyle(color: Colors.black)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _addMuted(name);
            },
            child: const Text('Mute', style: TextStyle(color: Colors.black)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          isDefaultAction: true,
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafe = MediaQuery.of(context).padding.top;
    final nickName = widget.figureData['DovoNickName'] as String? ?? '';
    final userIcon = widget.figureData['DovoUserIcon'] as String? ?? '';
    final photoArray = (widget.figureData['DovoShowPhotoArray'] as List?) ?? [];
    final motto = widget.figureData['DovoShowMotto'] as String? ?? '';
    final followNum = widget.figureData['DovoShowFollowNum'] as int? ?? 0;
    final likeNum = widget.figureData['DovoShowLike'] as int? ?? 0;
    final sayhi = widget.figureData['DovoShowSayhi'] as String? ?? '';

    // Get second photo URL for role image background
    String roleImageUrl = userIcon; // Fallback to userIcon
    if (photoArray.length > 1 && photoArray[1] is Map) {
      final secondPhoto = photoArray[1] as Map;
      if (secondPhoto['url'] != null) {
        roleImageUrl = secondPhoto['url'] as String;
      }
    }

    // Extract tags from photoArray
    final allTags = <String>{};
    for (var photo in photoArray) {
      if (photo is Map && photo['tags'] is List) {
        allTags.addAll((photo['tags'] as List).map((e) => e.toString()));
      }
    }
    final tagsList = allTags.toList().take(2).toList();

    // Extract age or use a default
    final age = 26; // Default age, can be extracted from data if available

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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
            child: GestureDetector(
              onTap: () => _showMoreActions(nickName),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.more_vert, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
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
        child: Stack(
          children: [
            SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main portrait at top (y=0) with mask overlay
              SizedBox(
                width: size.width,
                height: 350,
                child: Stack(
                  children: [
                    // Role image background
                    Image.asset(
                      roleImageUrl,
                      fit: BoxFit.cover,
                      width: size.width,
                      height: 350,
                      errorBuilder: (_, __, ___) => Container(
                        width: size.width,
                        height: 350,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
                    ),
                    // Mask image at bottom of portrait
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: size.width,
                        height: 161,
                        child: Image.asset(
                          'assets/figure_mask.webp',
                          fit: BoxFit.cover,
                          width: size.width,
                          height: 161,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Profile details section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Small profile picture
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          userIcon,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 30, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$nickName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tagsList.map((tag) {
                            Color tagColor;
                            switch (tag) {
                              case 'Recommend':
                                tagColor = const Color(0xFFFF7A7A);
                                break;
                              case 'Holiday':
                                tagColor = const Color(0xFF8AD3FF);
                                break;
                              case 'Anniversary':
                                tagColor = const Color(0xFFFFB6D0);
                                break;
                              case 'Birthday':
                                tagColor = const Color(0xFFFFB6D0);
                                break;
                              default:
                                tagColor = const Color(0xFF8AD3FF);
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: tagColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                  
                ),
              ),
              const SizedBox(height: 24),
              // Stats section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$likeNum',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Gift Ideas Shared',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4F9BF5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$followNum',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Gifts Given',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4F9BF5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Gift Stories title
              Center(
                child: Image.asset(
                  'assets/figure_gift.webp',
                  width: 160,
                  height: 37,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              // Gift Stories cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: photoArray.map((photo) {
                    final url = (photo is Map && photo['url'] != null) ? photo['url'] as String : '';
                    final title = (photo is Map && photo['title'] != null) ? photo['title'] as String : '';
                    final itemWidth = (size.width - 60) / 2.0;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GiftDetailPage(
                              photoData: photo as Map<String, dynamic>,
                              figureData: widget.figureData,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: itemWidth,
                        height: 210,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
            ),
            // Video and Message buttons positioned at top right
            Positioned(
              top: topSafe + 64,
              right: 20,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FigureChatPage(figureData: widget.figureData),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/figure_message.webp',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FigureVideoPage(figureData: widget.figureData),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/figure_video.webp',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

