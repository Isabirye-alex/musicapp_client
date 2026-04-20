import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/features/auth/view/pages/sign_up_page.dart';
import 'package:little_music/utilis/custom_text_button.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Login to Upload Songs',
            style: TextTheme.of(context).headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You need to be logged in to upload your music',
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: AColorTheme.subtitleText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CustomTextButton(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            ),
            text: 'Log In',
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextTheme.of(context).bodyLarge,
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                        (_) => false,
                      );
                    },
                  text: 'Sign up here',
                  style: TextStyle(color: AColorTheme.gradient3, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
