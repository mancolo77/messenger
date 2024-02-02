import 'package:flutter/material.dart';
import 'package:messenger/features/data/services/firebase_auth_service.dart';
import 'package:messenger/features/data/services/show_toast.dart';
import 'package:messenger/features/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

void signUp() async {
  final authService = Provider.of<FirebaseAuthService>(context, listen: false);
  try {
    await authService.signUpWithEmailAndPassword(
      emailController.text,
      passwordController.text,
      usernameController.text,
    );
  } catch (e) {
    showToast(e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const HeaderWidget(title: "Регистрация"),
        const SizedBox(height: 20),
        MyTextField(
          controller: usernameController, 
          obscureText: false,
          hintText: 'Имя пользователя',
        ),
        const SizedBox(height: 20),
        MyTextField(
          controller: emailController, 
          obscureText: false,
          hintText: 'Почта',
        ),
        const SizedBox(height: 20),
        MyTextField(
          controller: passwordController, 
          obscureText: true,
          hintText: 'Пароль',
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Зарегистрироваться',
          onTap: signUp,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Уже зарегистрированы?'),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text('Войдите!',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold
              ),
              ),
            )
          ],
        )
      ],
    ),
  ),
),
    );
  }
}