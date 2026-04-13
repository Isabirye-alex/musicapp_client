import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_button.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState!.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isObscureText = true;
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
                'It\'s a pleasure having you join us,',
                style: TextTheme.of(context).headlineLarge,
              ),
              Text(
                'Create Account.',
                style: TextTheme.of(context).headlineLarge,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                hintText: 'Name',
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 20),
              CustomTextField(
                onTap: () {
                  setState(() {
                    isObscureText == !isObscureText;
                  });
                },
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.password_outlined,
                suffixIcon: Icons.remove_red_eye_sharp,
                isObscureText: isObscureText,
              ),
              SizedBox(height: 20),
              CustomTextButton(onTap: () {}, text: 'Sign Up'),
              SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextTheme.of(context).bodyLarge,
                  children: [
                    TextSpan(
                      text: 'Log in here',
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
