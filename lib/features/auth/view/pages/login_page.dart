import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/widgets/error.dart';
import 'package:little_music/core/widgets/loader.dart';
import 'package:little_music/core/widgets/success.dart';
import 'package:little_music/features/auth/view/pages/sign_up_page.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_button.dart';
import 'package:little_music/features/auth/view/widgets/custom_text_field.dart';
import 'package:little_music/features/auth/viewModel/auth_viewmodel.dart';
import 'package:little_music/features/home/views/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
    final isLoading = ref.watch(authViewmodelProvider.select((val)=>val?.isLoading==true));
    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          SuccessHelper.showSuccess(
            context,
            'Welcome \'${data!.user.lastName}\'',
            'Success',
          );
        },
        error: (error, str) {
          ErrorHelper.showError(context, '$error', 'SignIn Error');
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
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(authViewmodelProvider.notifier)
                              .signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
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
