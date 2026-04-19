import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/features/home/views/pages/library_page.dart';
import 'package:little_music/features/home/views/pages/local_songs_page.dart';
import 'package:little_music/features/home/views/pages/music_slab.dart';
import 'package:little_music/features/home/views/pages/upload_song_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LibraryPage(),
      UploadSongPage(),
      LocalSongsPage(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 70,
        type: BottomNavigationBarType.fixed,

        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'UpLoad Song',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Local Songs',
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[selectedIndex],
          Positioned(bottom: 0, right: 16, left: 16, child: MusicSlab()),
        ],
      ),
    );
  }
}
