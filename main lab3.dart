import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gun Shop App', // Змінено назву застосунку
      theme: ThemeData(
        primarySwatch: Colors.grey, // Змінили основний колір
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        // Додавайте інші маршрути тут
      },
    );
  }
}
