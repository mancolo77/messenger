import 'package:flutter/material.dart';
import 'widgets/center_img.dart';
import 'widgets/login_button.dart';
import 'widgets/start_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Expanded(child: CenterDisplay()),
          bottomButtons(),
        ],
      ),
    );
  }
  
bottomButtons() {
  return Container(
    width: double.infinity,
    color: Colors.white,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StartButton(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogInButton(),
          ],
        ),
      ],
    ),
  );
}
}