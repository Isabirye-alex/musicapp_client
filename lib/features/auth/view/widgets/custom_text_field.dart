import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    required this.controller,
    this.isObscureText = false,
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
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? InkWell(onTap: onTap, child: Icon(suffixIcon))
            : null,
        prefixIcon: Icon(prefixIcon),
      ),
      obscureText: isObscureText,
      obscuringCharacter: '*',
      autofocus: false,
    );
  }
}
