import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/auth/repositories/auth_remote_repositry.dart';
import 'package:little_music/features/auth/view/pages/sign_up_page.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_button.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';
import 'package:fpdart/fpdart.dart' hide State;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
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
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.password_outlined,
                suffixIcon: Icons.remove_red_eye_sharp,
                isObscureText: isObscureText,
              ),
              SizedBox(height: 20),
              CustomTextButton(
                onTap: () async {
                  final user = UserModel(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  final res = await AuthRemoteRepository().signin(user);
                  switch (res) {
                    case Right():
                      clearFields();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Sucess')));

                    case Left(value: final l):
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('$l')));
                  }
                },
                text: 'Log In',
              ),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextTheme.of(context).bodyLarge,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },

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
