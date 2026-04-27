// Main entry point for the Little Music application
// This file initializes Flutter, Hive database, and Riverpod state management
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:little_music/core/theme/a_app_theme.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/features/home/views/pages/home_page.dart';
import 'package:path_provider/path_provider.dart';

/// Initializes the application and runs it
/// Sets up Hive for local storage and Riverpod for state management
void main() async {
  // Ensure Flutter bindings are initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory for Hive storage
  final dir = await getApplicationDocumentsDirectory();

  // Initialize Hive with the directory path
  Hive.init(dir.path);

  // Open the songs box for storing local song data
  await Hive.openBox('songs_box');

  // Create a ProviderContainer for Riverpod state management
  final container = ProviderContainer();

  // Initialize auth state from shared preferences
  final userNotifier = container.read(authViewmodelProvider.notifier);
  await userNotifier.initSharedPreferences();
  await userNotifier.getData();

  // Run the app with the provider scope
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

/// Root widget of the application
/// Configures theming and navigation
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
