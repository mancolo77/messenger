import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText, 
    this.onChanged, 
    this.focusNode
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor:const Color(0xFFEDF2F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9DB6CA))
      ),
    );
  }
}
