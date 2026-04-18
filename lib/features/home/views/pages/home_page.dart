import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/features/home/views/pages/library_page.dart';
import 'package:little_music/features/home/views/pages/upload_song_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [LibraryPage(), UploadSongPage()];

    int selectedIndex = 0;

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
            label: 'Log in',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sign Up'),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
