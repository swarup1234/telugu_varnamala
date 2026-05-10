import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const TeluguVarnamalaApp());

class TeluguVarnamalaApp extends StatelessWidget {
  const TeluguVarnamalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telugu Varnamala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
