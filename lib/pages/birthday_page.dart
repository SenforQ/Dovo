import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'gift_detail_page.dart';
import 'home_figure_page.dart';
import 'report_page.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({super.key});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  List<Map<String, dynamic>> _birthdayItems = [];
  Set<String> _blocked = <String>{};
  Set<String> _muted = <String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _blocked = (prefs.getStringList('blocked_users') ?? const <String>[]).toSet();
      _muted = (prefs.getStringList('muted_users') ?? const <String>[]).toSet();
    } catch (_) {
      _blocked = <String>{};
      _muted = <String>{};
    }
    await _loadBirthdayItems();
  }

  Future<void> _loadBirthdayItems() async {
    try {
      final raw = await rootBundle.loadString('assets/figur_detail.json');
      final data = jsonDecode(raw);
      List<dynamic> figures = (data is List) ? data : [];
      
      // Filter out blocked and muted users
      figures = figures.where((e) {
        if (e is Map && e['DovoNickName'] is String) {
          final name = e['DovoNickName'] as String;
          return !_blocked.contains(name) && !_muted.contains(name);
        }
        return true;
      }).toList();

      // Extract items with Birthday tag from DovoShowPhotoArray
      List<Map<String, dynamic>> birthdayItems = [];
      for (var figure in figures) {
        if (figure is! Map) continue;
        final photoArray = figure['DovoShowPhotoArray'];
        if (photoArray is List) {
          for (var photo in photoArray) {
            if (photo is Map) {
              final tags = photo['tags'];
              if (tags is List && tags.contains('Birthday')) {
                // Add photo data with figure data
                birthdayItems.add({
                  'photoData': photo,
                  'figureData': figure,
                });
              }
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _birthdayItems = birthdayItems;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading birthday items: $e');
      if (mounted) {
        setState(() {
          _birthdayItems = [];
          _loading = false;
        });
      }
    }
  }

  Future<void> _addBlocked(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _blocked.add(name);
    await prefs.setStringList('blocked_users', _blocked.toList());
    await _loadData();
  }

  Future<void> _addMuted(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _muted.add(name);
    await prefs.setStringList('muted_users', _muted.toList());
    await _loadData();
  }

  void _showMoreActionsFor(String name) {
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
    final double topSafe = MediaQuery.of(context).padding.top;
    
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
        title: const Text('Birthday'),
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _birthdayItems.isEmpty
                      ? const Center(child: Text('No birthday items found'))
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              ..._birthdayItems.map((item) {
                                final photoData = item['photoData'] as Map<String, dynamic>;
                                final figureData = item['figureData'] as Map<String, dynamic>;
                                final url = photoData['url'] as String? ?? '';
                                final tags = (photoData['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];
                                final userIcon = figureData['DovoUserIcon'] as String? ?? '';
                                final nickName = figureData['DovoNickName'] as String? ?? '';
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _BirthdayCardItem(
                                    photoUrl: url,
                                    figureData: figureData,
                                    userIcon: userIcon,
                                    nickName: nickName,
                                    tags: tags,
                                    onMore: _showMoreActionsFor,
                                    onCardTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => GiftDetailPage(
                                            photoData: photoData,
                                            figureData: figureData,
                                          ),
                                        ),
                                      );
                                    },
                                    onFigureTap: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => HomeFigurePage(figureData: figureData),
                                        ),
                                      );
                                      // Reload data after returning from detail page
                                      _loadData();
                                    },
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

class _BirthdayCardItem extends StatelessWidget {
  final String photoUrl;
  final Map<String, dynamic> figureData;
  final String userIcon;
  final String nickName;
  final List<String> tags;
  final void Function(String) onMore;
  final VoidCallback onCardTap;
  final VoidCallback onFigureTap;

  const _BirthdayCardItem({
    required this.photoUrl,
    required this.figureData,
    required this.userIcon,
    required this.nickName,
    this.tags = const [],
    required this.onMore,
    required this.onCardTap,
    required this.onFigureTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Main card container with top margin 12
            Positioned.fill(
              top: 12,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: onCardTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2C27B8), width: 2),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Image.asset(
                                userIcon,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        // bottom-left tags
                        Positioned(
                          left: 20,
                          bottom: 16,
                          child: Row(
                            children: [
                              ...tags.take(2).map((t) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _TagChip(text: t),
                                  )),
                            ],
                          ),
                        ),
                        // top-right transparent black three-dots button
                        Positioned(
                          top: 24,
                          right: 24,
                          child: GestureDetector(
                            onTap: () => onMore(nickName),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ),
                        // Character info overlay at top-left
                        Positioned(
                          top: 16,
                          left: 16,
                          child: GestureDetector(
                            onTap: onFigureTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        userIcon,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    nickName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                ),
              ),
            ),
            // Top badge image centered at y=0, size 68x40
            SizedBox(
              width: 68,
              height: 40,
              child: Image.asset(
                'assets/home_iteam_top.webp',
                width: 68,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip({required this.text});

  Color _bg(String t) {
    switch (t) {
      case 'Recommend':
        return const Color(0xFFFF7A7A); // 浅红
      case 'Holiday':
        return const Color(0xFF8AD3FF); // 浅蓝
      case 'Anniversary':
        return const Color(0xFFFFB6D0); // 浅粉
      case 'Birthday':
        return const Color(0xFFFFB6D0); // 浅粉
      default:
        return const Color(0xFF8AD3FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg(text),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

