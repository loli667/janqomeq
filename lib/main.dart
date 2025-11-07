import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'homescreen.dart';
import 'chat_page.dart';
import 'moodscreen.dart';
import 'registerscreen.dart';
import 'practicescreen.dart';
import 'profilescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatPage(),
        '/mood': (context) => const MoodPage(),
        '/register': (context) => const RegisterScreen(),
        '/practice': (context) => const PracticeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
