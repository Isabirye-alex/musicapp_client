import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_music/core/providers/current_user_notifier.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AColorTheme.whiteColor.withAlpha(20)
                : AColorTheme.transparentColor.withAlpha(230),
            border: Border(
              bottom: BorderSide(
                color: AColorTheme.whiteColor.withAlpha(40),
                width: 0.8,
              ),
            ),
            gradient: LinearGradient(
              colors: [
                isDark
                    ? AColorTheme.whiteColor.withAlpha(25)
                    : AColorTheme.backgroundColor.withAlpha(25),
                isDark
                    ? AColorTheme.whiteColor.withAlpha(10)
                    : AColorTheme.backgroundColor.withAlpha(10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Greeting + Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getGreeting(),
                        style: TextStyle(
                          color: isDark
                              ? AColorTheme.whiteColor.withAlpha(160)
                              : AColorTheme.backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        capitalize(currentUser?.lastName ?? 'Listener'),
                        style: TextStyle(
                          color: isDark
                              ? AColorTheme.whiteColor
                              : AColorTheme.backgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Notification bell
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AColorTheme.whiteColor.withAlpha(30)
                                  : AColorTheme.backgroundColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AColorTheme.whiteColor.withAlpha(50),
                                width: 0.8,
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: isDark
                                  ? AColorTheme.whiteColor
                                  : AColorTheme.backgroundColor,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AColorTheme.accent.withAlpha(250),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  // Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AColorTheme.whiteColor.withAlpha(80)
                                : AColorTheme.backgroundColor.withAlpha(80),
                            width: 1.5,
                          ),
                          color: isDark
                              ? AColorTheme.whiteColor.withAlpha(20)
                              : AColorTheme.backgroundColor.withAlpha(20),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent,
                          child: currentUser?.userAvatar.isNotEmpty == true
                              ? ClipOval(
                                  child: Image.network(
                                    currentUser!.userAvatar,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.person,
                                          color: isDark
                                              ? AColorTheme.whiteColor
                                              : AColorTheme.backgroundColor,
                                          size: 20,
                                        ),
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: isDark
                                      ? AColorTheme.whiteColor
                                      : AColorTheme.backgroundColor,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
