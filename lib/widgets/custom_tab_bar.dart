import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final tabBarHeight = bottomSafeArea + 58;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: tabBarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TabItem(
                    index: 0,
                    currentIndex: currentIndex,
                    normalImage: 'assets/tab_home_n.webp',
                    selectedImage: 'assets/tab_home_s.webp',
                    onTap: () => onTap(0),
                  ),
                  _TabItem(
                    index: 1,
                    currentIndex: currentIndex,
                    normalImage: 'assets/tab_community_n.webp',
                    selectedImage: 'assets/tab_community_s.webp',
                    onTap: () => onTap(1),
                  ),
                  _TabItem(
                    index: 2,
                    currentIndex: currentIndex,
                    normalImage: 'assets/tab_message_n.webp',
                    selectedImage: 'assets/tab_message_s.webp',
                    onTap: () => onTap(2),
                  ),
                  _TabItem(
                    index: 3,
                    currentIndex: currentIndex,
                    normalImage: 'assets/tab_mine_n.webp',
                    selectedImage: 'assets/tab_mine_s.webp',
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),
            SizedBox(height: bottomSafeArea),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String normalImage;
  final String selectedImage;
  final VoidCallback onTap;

  const _TabItem({
    required this.index,
    required this.currentIndex,
    required this.normalImage,
    required this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Image.asset(
          isSelected ? selectedImage : normalImage,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

