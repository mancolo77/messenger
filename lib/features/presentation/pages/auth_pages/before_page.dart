 import 'package:flutter/material.dart';
import 'package:messenger/features/presentation/pages/pages.dart';

class BeforePage extends StatefulWidget {
  const BeforePage({super.key});

  @override
  State<BeforePage> createState() => _BeforePageState();
}

class _BeforePageState extends State<BeforePage> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!showLoginPage){
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}