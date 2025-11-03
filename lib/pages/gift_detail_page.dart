import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_page.dart';

class GiftDetailPage extends StatefulWidget {
  final Map<String, dynamic> photoData;
  final Map<String, dynamic> figureData;
  
  const GiftDetailPage({
    super.key,
    required this.photoData,
    required this.figureData,
  });

  @override
  State<GiftDetailPage> createState() => _GiftDetailPageState();
}

class _GiftDetailPageState extends State<GiftDetailPage> {
  bool _isLiked = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
    _loadFavoriteStatus();
  }

  Future<void> _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final url = widget.photoData['url'] as String? ?? '';
    final liked = prefs.getBool('gift_liked_$url') ?? false;
    if (mounted) {
      setState(() {
        _isLiked = liked;
      });
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final url = widget.photoData['url'] as String? ?? '';
    final favorites = prefs.getStringList('gift_favorites') ?? const <String>[];
    if (mounted) {
      setState(() {
        _isFavorited = favorites.contains(url);
      });
    }
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final url = widget.photoData['url'] as String? ?? '';
    final newStatus = !_isLiked;
    await prefs.setBool('gift_liked_$url', newStatus);
    if (mounted) {
      setState(() {
        _isLiked = newStatus;
      });
    }
  }

  Future<void> _addToFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final url = widget.photoData['url'] as String? ?? '';
    final favorites = (prefs.getStringList('gift_favorites') ?? const <String>[]).toList();
    
    if (_isFavorited) {
      // Already favorited, show message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already favorited'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    
    // Add to favorites
    favorites.add(url);
    await prefs.setStringList('gift_favorites', favorites);
    if (mounted) {
      setState(() {
        _isFavorited = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
    
    final url = widget.photoData['url'] as String? ?? '';
    final title = widget.photoData['title'] as String? ?? '';
    final content = widget.photoData['content'] as String? ?? '';
    final tags = (widget.photoData['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final nickName = widget.figureData['DovoNickName'] as String? ?? '';
    final userIcon = widget.figureData['DovoUserIcon'] as String? ?? '';

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
          'assets/gift_title.webp',
          width: 270,
          height: 30,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4F9BF5),
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
            // Role image
            Positioned(
              top: topSafe + 55,
              left: 0,
              right: 0,
              height: 320,
              child: Image.asset(
                url,
                width: size.width,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: size.width,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            ),
          // Top-left badge with profile
          Positioned(
            top: topSafe + 55 + 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C27B8).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
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
                  const SizedBox(width: 8),
                  Text(
                    nickName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side buttons
          Positioned(
            top: topSafe + 55 + 20,
            right: 16,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleLike,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isLiked ? Colors.red : const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _showMoreActions(nickName),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B9D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.waving_hand, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
          // Content View positioned below image (20px from bottom, 20px horizontal padding, 20px border radius)
          Positioned(
            top: topSafe + 55 + 20 + 320,
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: GestureDetector(
                        onTap: _addToFavorite,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/gift_add_list.webp',
                              width: 224,
                              height: 46,
                              fit: BoxFit.contain,
                            ),
                            if (_isFavorited)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
    );
  }
}

