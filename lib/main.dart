import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PokemonCardViewerApp());
}

class PokemonCardViewerApp extends StatelessWidget {
  const PokemonCardViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Card Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
