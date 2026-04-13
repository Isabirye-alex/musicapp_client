import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    required this.controller,
    this.isObscureText = true,
  });

  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: InkWell(onTap: onTap, child: Icon(suffixIcon)),
        prefixIcon: Icon(prefixIcon),
      ),
      obscureText: isObscureText,
      obscuringCharacter: '*',
      autofocus: true,
      validator: (val) {
        if (val!.trim().isEmpty) {
          return '$hintText is missing';
        } else {
          return null;
        }
      },
    );
  }
}
