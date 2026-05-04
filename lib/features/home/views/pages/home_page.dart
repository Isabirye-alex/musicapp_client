import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/viewModels/token_register_viewmodel.dart';
import 'package:little_music/features/home/views/pages/library_page.dart';
import 'package:little_music/features/home/views/pages/music_slab.dart';
import 'package:little_music/features/home/views/pages/profile_page.dart';
import 'package:little_music/features/home/views/pages/recently_played_songs.dart';
import 'package:little_music/features/home/views/pages/your_uploads.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Library'),
    _NavItem(icon: CupertinoIcons.upload_circle_fill, label: 'Uploads'),
    _NavItem(icon: Icons.history_rounded, label: 'Recent'),
    _NavItem(icon: Icons.account_circle_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _registerToken();
  }

  Future<void> _registerToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await ref
        .read(tokenRegisterViewmodelProvider.notifier)
        .registerToken(token, 'Android');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LibraryPage(),
      YourUploads(),
      RecentlyPlayedSongs(),
      ProfilePage(),
    ];

    final primary = AColorTheme.gradient1;

    return Scaffold(
      extendBody: false,
      body: Column(
        children: [
          Expanded(child: pages[selectedIndex]),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: MusicSlab(),
          ),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: AColorTheme.backgroundColor.withAlpha(220),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: AColorTheme.primaryDark.withAlpha(30),
                blurRadius: 30,
                spreadRadius: 2,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // animated selected indicator
              AnimatedAlign(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment(
                  -1 + (selectedIndex * (2 / (_navItems.length - 1))),
                  0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1 / _navItems.length,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(76),
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
              ),

              // nav items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.2 : 1.0,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              item.icon,
                              size: 24,
                              color: isSelected ? primary : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 250),
                            style: TextStyle(
                              color: isSelected ? primary : Colors.transparent,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
