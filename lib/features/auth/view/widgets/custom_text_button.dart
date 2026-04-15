import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text, style: TextTheme.of(context).bodyLarge),
      ),
    );
  }
}
