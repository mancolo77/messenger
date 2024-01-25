import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger_test/service/snackbar.dart';
import '../service/firebase_auth_service.dart';
import 'widgets/form_container_widget.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;
  
  @override
  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Icon(
                  Icons.account_circle_outlined,
                  size: 80,
                  color: Colors.greenAccent[900],
                ),
                const SizedBox(height: 20),
                const Text("Создайте аккаунт",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
              const SizedBox(height: 25),
              FormContainerWidget(
              hintText: 'Имя пользователя',
              controller: _usernameController,
              isPasswordField: false,
            ),
              const SizedBox(height: 25),
              FormContainerWidget(
              hintText: 'Почта',
              controller: _emailController,
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
                _signUp();
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
                  child: Text("Зарегистрироваться", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto',fontWeight: FontWeight.w900),),
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
                      color: Colors.blue, // Или любой другой цвет, который вы хотите использовать для текста "Назад"
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ),
        ),
      ),
      ),
    );
  }
  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password, username);

  setState(() {
    isSigningUp = false;
  });
  if(user != null){
    MySnackBar.showSnackBar(context, "Пользователь успешно создан");
    Get.toNamed('/home');
  } else {
    MySnackBar.showSnackBar(context, "Произошла ошибка");
  }
  }
}