
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:little_music/core/theme/a_app_theme.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/features/home/views/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.yourapp.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    );
  } catch (e) {
    // Log error but continue - audio playback will still work without background service
    debugPrint('JustAudioBackground initialization failed: $e');
  }

  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  await Hive.openBox('songs_box');

  final container = ProviderContainer();

  final userNotifier = container.read(authViewmodelProvider.notifier);
  await userNotifier.initSharedPreferences();
  await userNotifier.getData();

  // Run the app with the provider scope
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ATLAS',
      themeMode: ThemeMode.system,
      theme: AAppTheme.lightTheme,
      darkTheme: AAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
