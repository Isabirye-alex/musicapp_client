import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/features/auth/model/user_model.dart';
import 'package:little_music/features/auth/repositories/auth_remote_repositry.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_button.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState!.validate();
    super.dispose();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
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
                'It\'s a pleasure having you join us,',
                style: TextTheme.of(context).headlineLarge,
              ),
              Text(
                'Create Account.',
                style: TextTheme.of(context).headlineLarge,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: firstNameController,
                hintText: 'First Name',
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: lastNameController,
                hintText: 'Last Name',
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
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  await AuthRemoteRepository().signup(user);
                  clearFields();
                },
                text: 'Sign Up',
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextTheme.of(context).bodyLarge,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
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
