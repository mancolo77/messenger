import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomButton({super.key, this.onTap, required this.text});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Center(
          child: Center(
            child: Text(text,
             style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
             ) ,),
          ),
        ),
      ),
    );
  }
}