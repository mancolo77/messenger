import 'package:flutter/material.dart';
import 'package:messenger/features/data/services/firebase_auth_service.dart';
import 'package:messenger/features/data/services/show_toast.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void signIn() async{
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    try{
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        );
    } catch (e){
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
        const HeaderWidget(title: "Логин"),
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
          text: 'Войти',
          onTap: signIn
        ),
        const SizedBox(height: 20),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Нет аккаунта?'),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text('Зарегистрируйтесь!',
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