import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/utilis/error.dart';
import 'package:little_music/utilis/loader.dart';
import 'package:little_music/features/auth/view/pages/login_page.dart';
import 'package:little_music/utilis/custom_text_field.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';

import '../../../../utilis/custom_text_button.dart';
import '../../../../utilis/success.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
    final isLoading = ref.watch(
      authViewmodelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          if (data == null) {
            //null means signup success (no user returned yet)
            SuccessHelper.showSuccess(
              context,
              'User Registered Successfully',
              'Success',
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (_) => false,
            );
          }
        },
        error: (error, str) {
          ErrorHelper.showError(context, '$error', 'SignUp Error');
        },
        loading: () {},
      );
    });

    return Scaffold(
      // appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
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
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(authViewmodelProvider.notifier)
                              .signup(
                                firstNameController.text.trim(),
                                lastNameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        } else {}
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
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (_) => false,
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
