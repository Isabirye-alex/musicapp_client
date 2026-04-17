import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/current_user_notifier.dart';
import 'package:little_music/core/theme/a_app_theme.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/features/home/upload_song_page.dart';

import 'features/home/views/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final userNotifier = container.read(authViewmodelProvider.notifier);
  await userNotifier.initSharedPreferences();
  await userNotifier.getData();

  runApp(
      UncontrolledProviderScope(
      container: container,
      child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'MusicApp',
      themeMode: ThemeMode.system,
      theme: AAppTheme.lightTheme,
      darkTheme: AAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: currentUser !=null ? UploadSongPage() : LoginPage(),
    );
  }
}
