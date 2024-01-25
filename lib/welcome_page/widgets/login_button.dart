import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ElevatedButton(
        onPressed: (){
            Get.offAllNamed('/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00ACF6),
          elevation: 5,
          shape: 
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: const Text(
          'У меня есть аккаунт',
          style: TextStyle(
            color:  Colors.white, fontSize: 20, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}