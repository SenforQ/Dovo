import 'dart:io';
import 'package:flutter/material.dart';
import 'user_agreement_page.dart';
import 'privacy_policy_page.dart';
import 'setting_page.dart';
import '../services/user_profile.dart';
import 'about_us_page.dart';
import 'message_page.dart';
import 'wallet_page.dart';
import 'vip_page.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafeArea = MediaQuery.of(context).padding.top;
    final double scale = size.height / 812.0;
    final double topMargin = topSafeArea + 25 * scale;
    final manager = UserProfileManager();
    // 触发一次异步加载（幂等）
    manager.load();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: topMargin),
              ValueListenableBuilder<UserProfile>(
                valueListenable: manager.notifier,
                builder: (context, profile, _) {
                  return FutureBuilder<String?>(
                    future: manager.buildAvatarFullPath(profile.avatarFileName),
                    builder: (context, snap) {
                      final String? fullPath = snap.data;
                      final ImageProvider provider = (fullPath != null && fullPath.isNotEmpty)
                          ? Image.file(File(fullPath)).image
                          : const AssetImage('assets/app_default_headerIcon.webp');
                      return Container(
                        width: 94 * scale,
                        height: 94 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2 * scale,
                          ),
                        ),
                        child: ClipOval(
                          child: Image(
                            image: provider,
                            width: 94 * scale,
                            height: 94 * scale,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 11 * scale),
              ValueListenableBuilder<UserProfile>(
                valueListenable: manager.notifier,
                builder: (context, profile, _) {
                  return Text(
                    profile.nickname,
                    style: TextStyle(
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B0B0B),
                    ),
                  );
                },
              ),

              // VIP banner
              SizedBox(height: 16 * scale),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VipPage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 150 * scale,
                  width: size.width,
                  child: Image.asset(
                    'assets/mine_vip.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Wallet banner
              SizedBox(height: 10 * scale),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WalletPage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 52 * scale,
                  width: size.width,
                  child: Image.asset(
                    'assets/mine_wallet.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: 8 * scale),

              // Five items grid (3 per row)
              _MineItemsGrid(scale: scale, screenWidth: size.width),
              SizedBox(height: 24 * scale),
            ],
          ),
        ),
      ),
    );
  }
}

class _MineItemsGrid extends StatelessWidget {
  final double scale;
  final double screenWidth;

  const _MineItemsGrid({
    required this.scale,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double spacing = 20 * scale;
    final double containerHorizontalPadding = 0;
    final double effectiveWidth = screenWidth - (80 * scale);
    final double itemWidth = (effectiveWidth / 3);
    final double itemHeight =108 * scale;
    final double iconSize = 42 * scale;

    final List<String> icons = const [
      'assets/mine_setting.webp',
      'assets/mine_privacy_policy.webp',
      'assets/mine_user_agreement.webp',
      'assets/mine_aboutus.webp',
      'assets/mine_message.webp',
    ];

    final List<String> labels = const [
      'Setting',
      'Privacy Policy',
      'User Agreement',
      'About us',
      'Message',
    ];

    final double horizontalPadding = (40 * scale) + containerHorizontalPadding;
    final double availableWidth = screenWidth - horizontalPadding * 2;
    final double calculatedItemWidth = (availableWidth - spacing * 2) / 3; // 两个间距 = 3列-1
    final double childAspectRatio = calculatedItemWidth / itemHeight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GridView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final content = Container(
            width: calculatedItemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: Border.all(color: const Color(0xFF000000), width: 2 * scale),
              borderRadius: BorderRadius.circular(16 * scale),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16 * scale),
                Image.asset(
                  icons[index],
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 6 * scale),
                Flexible(
                  child: Text(
                    labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 16 * scale),
              ],
            ),
          );

          if (index == 0) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SettingPage(),
                  ),
                );
              },
              child: content,
            );
          }

          if (index == 2) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UserAgreementPage(),
                  ),
                );
              },
              child: content,
            );
          }

          if (index == 1) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyPage(),
                  ),
                );
              },
              child: content,
            );
          }

          if (index == 3) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AboutUsPage(),
                  ),
                );
              },
              child: content,
            );
          }

          if (index == 4) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MessagePage(),
                  ),
                );
              },
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }
}

