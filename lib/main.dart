import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/theme/a_app_theme.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final userNotifier = container.read(authViewmodelProvider.notifier);
  await userNotifier.initSharedPreferences();
  final user = await userNotifier.getData();

  runApp(
      UncontrolledProviderScope(
      container: container,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicApp',
      themeMode: ThemeMode.system,
      theme: AAppTheme.lightTheme,
      darkTheme: AAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
