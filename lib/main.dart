import 'package:flutter/material.dart';
import 'services/user_profile.dart';
import 'pages/home_page.dart';
import 'pages/community_page.dart';
import 'pages/planning_page.dart';
import 'pages/mine_page.dart';
import 'widgets/custom_tab_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserProfileManager().load();
  runApp(const DovoApp());
}

class DovoApp extends StatelessWidget {
  const DovoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dovo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFFFFFF),
          onPrimary: Colors.black,
          secondary: const Color(0xFFFFFFFF),
          onSecondary: Colors.black,
          surface: const Color(0xFFFFFFFF),
          onSurface: Colors.black,
          background: const Color(0xFFFFFFFF),
          onBackground: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: MainTabPage(key: MainTabPage.tabKey),
    );
  }
}

class MainTabPage extends StatefulWidget {
  static final GlobalKey<MainTabPageState> tabKey = GlobalKey<MainTabPageState>();
  
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => MainTabPageState();
}

class MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CommunityPage(),
    PlanningPage(),
    MinePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void switchToTab(int index) {
    _onTabTapped(index);
  }

  static MainTabPageState? of(BuildContext context) {
    // Try to find via context first
    final state = context.findAncestorStateOfType<MainTabPageState>();
    if (state != null) return state;
    // Fallback to global key
    return MainTabPage.tabKey.currentState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTabBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),
          ),
        ],
      ),
    );
  }
}
