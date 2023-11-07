import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/screens/home_screen.dart';
import 'package:quiz_app/src/features/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      //home: const WelcomeScreen(),
    );
  }
}


