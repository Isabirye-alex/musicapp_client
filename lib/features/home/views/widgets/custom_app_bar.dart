import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/utilis/greeting_helper.dart';
import 'package:little_music/utilis/name_helper.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.title});

  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider)?.user;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C3FC8), Color(0xFFE040A0), Color(0xFFFF6D3F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x55E040A0),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    ' ${getGreeting()}, ${capitalize(currentUser?.lastName ?? "Listener")}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),

                  Spacer(),

                  // Notifications
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD740),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  // Profile
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(60),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF6C3FC8),
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
