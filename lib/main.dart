import 'package:flutter/material.dart';

import 'core/di/injection.dart';

void main() {
  configureDependencies();
  runApp(const SaluzApp());
}

class SaluzApp extends StatelessWidget {
  const SaluzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'saLuz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'saLuz',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),
      ),
    );
  }
}
