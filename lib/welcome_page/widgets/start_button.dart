import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
  return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.only(bottom: 2),
      child: ElevatedButton(
        onPressed: (){
             Get.offAllNamed('/register');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1EDA5E),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
        child: const Text(
          'Начать',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
}
}