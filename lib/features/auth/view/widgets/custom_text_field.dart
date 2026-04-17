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
    this.readOnly = false,
    this.songOnTap
  });

  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final VoidCallback? songOnTap;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {


    return TextFormField(
      textAlign: TextAlign.start,
      maxLines: 3,
      onTap: songOnTap,
      readOnly: readOnly,
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
        prefixIcon: prefixIcon !=null ? Icon(prefixIcon) : null,

      ),
      obscureText: isObscureText,
      obscuringCharacter: '*',
      autofocus: false,
    );
  }
}
