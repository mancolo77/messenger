import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../presentation/pages/pages.dart';

class CheckUser extends StatelessWidget {
  const CheckUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const HomePage();
          } else {
            return const BeforePage();
          }
        },
      ),
    );
  }
}