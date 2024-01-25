import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/firebase_auth_service.dart';
import '../service/snackbar.dart';
import 'widgets/form_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.account_circle_outlined,
                  size: 80,
                  color: Colors.greenAccent[900],
                ),
                const SizedBox(height: 50),
                const Text(
                  "Войдите в  Messenger",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                FormContainerWidget(
                  hintText: 'Почта',
                  controller: _emailContoller,
                  isPasswordField: false,
                ),
                const SizedBox(height: 25),
                FormContainerWidget(
                  hintText: 'Пароль',
                  controller: _passwordController,
                  isPasswordField: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    _signIn();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: ShapeDecoration(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Войти",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/');
                  },
                  child: const Text(
                    "Назад",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      isSigning = true;
    });
    String email = _emailContoller.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      isSigning = false;
    });
    if (user != null) {
      String? username = await _auth.getUsername(user.uid);
      if (username != null) {
        print('Вход успешен. Username: $username');
      } else {
        print('Не удалось получить Username');
      }
      MySnackBar.showSnackBar(context, "Успешный вход");
      Get.offAllNamed('/home');
    } else {
      MySnackBar.showSnackBar(context, "Ошибка");
    }
  }
}
