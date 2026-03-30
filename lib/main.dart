import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameController(),
      child: MaterialApp(
        title: 'Stratejik Sayı Birleştirme',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFB74D),
            secondary: Color(0xFFCE93D8),
            surface: Color(0xFF1C1026),
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0A12),
        ),
        home: const GameScreen(),
      ),
    );
  }
}
