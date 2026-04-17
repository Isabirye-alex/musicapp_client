import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/current_user_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserProvider);
    final user = userData!.user;

    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Column(
        children: [
          Text(user.firstName),
          Text(user.lastName),
          Text(user.email),

        ],
      )),
    );
  }
}
