import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 70,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) => setState(() => selectedIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Library'),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.upload_circle),
            label: 'Your Uploads',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Recent'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          // page takes all available space
          Expanded(child: pages[selectedIndex]),

          //slab always pinned at bottom above nav bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MusicSlab(),
          ),
        ],
      ),
    );
  }
}
