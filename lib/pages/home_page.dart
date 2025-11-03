import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'report_page.dart';
import 'home_figure_page.dart';
import 'birthday_page.dart';
import 'holiday_page.dart';
import 'anniversary_page.dart';
import '../main.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/coin_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _figures = const [];
  Set<String> _blocked = <String>{};
  Set<String> _muted = <String>{};
  Set<String> _unlocked = <String>{};

  @override
  void initState() {
    super.initState();
    _loadPrefsAndFigures();
  }

  Future<void> _loadPrefsAndFigures() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _blocked = (prefs.getStringList('blocked_users') ?? const <String>[]) .toSet();
      _muted = (prefs.getStringList('muted_users') ?? const <String>[]) .toSet();
      _unlocked = (prefs.getStringList('unlocked_figures') ?? const <String>[]) .toSet();
    } catch (_) {
      _blocked = <String>{};
      _muted = <String>{};
      _unlocked = <String>{};
    }
    await _reloadFigures();
  }

  Future<void> _unlockFigure(String nickName) async {
    final hasEnough = await CoinService.hasEnoughCoins(200);
    if (!hasEnough) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient coins. You need 200 coins to unlock.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final success = await CoinService.spendCoins(200);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      _unlocked.add(nickName);
      await prefs.setStringList('unlocked_figures', _unlocked.toList());
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully unlocked!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unlock. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _reloadFigures() async {
    try {
      final raw = await rootBundle.loadString('assets/figur_detail.json');
      final data = jsonDecode(raw);
      List<dynamic> list = (data is List) ? data : [];
      // filter out blocked or muted by nickname
      list = list.where((e) {
        if (e is Map && e['DovoNickName'] is String) {
          final name = e['DovoNickName'] as String;
          return !_blocked.contains(name) && !_muted.contains(name);
        }
        return true;
      }).toList();
      if (mounted) setState(() => _figures = list);
    } catch (_) {
      if (mounted) setState(() => _figures = const []);
    }
  }

  Future<void> _addBlocked(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _blocked.add(name);
    await prefs.setStringList('blocked_users', _blocked.toList());
    await _reloadFigures();
  }

  Future<void> _addMuted(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _muted.add(name);
    await prefs.setStringList('muted_users', _muted.toList());
    await _reloadFigures();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double topSafe = MediaQuery.of(context).padding.top;
    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    final double tabBarHeight = bottomSafe + 58; // 与自定义 TabBar 高度一致
    final double scrollHeight = size.height - topSafe - tabBarHeight;
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
            SizedBox(
              width: size.width,
              height: scrollHeight,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部大图：左右边距为 20，宽度自适应，高度按宽度等比
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Switch to Community tab (index 1)
                          final mainTabState = MainTabPageState.of(context);
                          if (mainTabState != null) {
                            mainTabState.switchToTab(1);
                          } else {
                            debugPrint('MainTabPageState not found');
                          }
                        },
                        child: Image.asset(
                          'assets/home_top_bg.webp',
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 横向滚动分类卡片
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _CategoryItem(
                              image: 'assets/home_birthday.webp',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const BirthdayPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            _CategoryItem(
                              image: 'assets/home_holiday.webp',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const HolidayPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            _CategoryItem(
                              image: 'assets/home_anniversary.webp',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AnniversaryPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          ..._figures.asMap().entries.map((entry) {
                            final index = entry.key;
                            final e = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _HomeCardItem(
                                index: index,
                                figureData: e as Map<String, dynamic>,
                                userIcon: (e['DovoUserIcon'] ?? '') as String,
                                nickName: (e['DovoNickName'] ?? '') as String,
                                tags: (() {
                                  final arr = e['DovoShowPhotoArray'];
                                  if (arr is List && arr.isNotEmpty) {
                                    final first = arr.first;
                                    if (first is Map && first['tags'] is List) {
                                      return List<String>.from(first['tags']);
                                    }
                                  }
                                  return <String>[];
                                })(),
                                isUnlocked: index < 3 || _unlocked.contains((e['DovoNickName'] ?? '') as String),
                                onMore: _showMoreActionsFor,
                                onUnlock: () => _unlockFigure((e['DovoNickName'] ?? '') as String),
                                onCardTap: () async {
                                  if (index < 3 || _unlocked.contains((e['DovoNickName'] ?? '') as String)) {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => HomeFigurePage(figureData: e as Map<String, dynamic>),
                                      ),
                                    );
                                    // Reload data after returning from detail page
                                    _loadPrefsAndFigures();
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
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

class _CategoryItem extends StatelessWidget {
  final String image;
  final VoidCallback? onTap;
  const _CategoryItem({required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        height: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            width: 120,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _HomeCardItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> figureData;
  final String userIcon;
  final String nickName;
  final List<String> tags;
  final bool isUnlocked;
  final void Function(String) onMore;
  final VoidCallback onUnlock;
  final VoidCallback onCardTap;
  const _HomeCardItem({
    required this.index,
    required this.figureData,
    required this.userIcon,
    required this.nickName,
    this.tags = const [],
    required this.isUnlocked,
    required this.onMore,
    required this.onUnlock,
    required this.onCardTap,
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
                              userIcon,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        // bottom-left tags from first photo's tags
                        if (isUnlocked)
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
                        if (isUnlocked)
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
                        // 玻璃蒙版和解锁按钮（未解锁时显示）
                        if (!isUnlocked)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF2C27B8), width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.1),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                            size: 48,
                                          ),
                                          const SizedBox(height: 16),
                                          GestureDetector(
                                            onTap: onUnlock,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFF5197FF), Color(0xFF72F6FF)],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    '200',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
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
// Show iOS-style action sheet for a specific nickname
extension _HomeActions on _HomePageState {
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
}
