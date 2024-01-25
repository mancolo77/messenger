import 'package:flutter/material.dart';
class CenterDisplay extends StatelessWidget {
  const CenterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
        width: 450.0,
        height: 450.0,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/test.png'),
          fit: BoxFit.cover,
          ),
          )
        ),
      ),
    );
  }
}