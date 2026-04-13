import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_button.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'We\'re happy to see you back,',
                style: TextTheme.of(context).headlineLarge,
              ),
              Text(
                'Log In To Your Account.',
                style: TextTheme.of(context).headlineLarge,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.password_outlined,
                suffixIcon: Icons.remove_red_eye_sharp,
              ),
              SizedBox(height: 20),
              CustomTextButton(onTap:(){} ,text: 'Log In'),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextTheme.of(context).bodyLarge,
                  children: [
                    TextSpan(
                      text: 'Sign up here',
                      style: TextStyle(
                        color: AColorTheme.gradient3,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
