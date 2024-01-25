import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/auth_page/registr_page.dart';
import 'package:messenger_test/chat_page/pages/main_chat_page.dart';
import 'package:messenger_test/welcome_page/welcome_page.dart';
import 'auth_page/login_page.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messengder',
      getPages: [
        GetPage(name: '/', page: () => const WelcomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: ()=> const SignUpPage()),
        GetPage(name: '/home', page: () => const MainChatPage()),
      ],
    );
  }
}
