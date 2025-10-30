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
        fontFamily: 'PokemonSolid',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'PokemonSolid'),
          displayMedium: TextStyle(fontFamily: 'PokemonSolid'),
          displaySmall: TextStyle(fontFamily: 'PokemonSolid'),
          headlineLarge: TextStyle(fontFamily: 'PokemonSolid'),
          headlineMedium: TextStyle(fontFamily: 'PokemonSolid'),
          headlineSmall: TextStyle(fontFamily: 'PokemonSolid'),
          titleLarge: TextStyle(fontFamily: 'PokemonSolid'),
          titleMedium: TextStyle(fontFamily: 'PokemonSolid'),
          titleSmall: TextStyle(fontFamily: 'PokemonSolid'),
          bodyLarge: TextStyle(fontFamily: 'PokemonSolid'),
          bodyMedium: TextStyle(fontFamily: 'PokemonSolid'),
          bodySmall: TextStyle(fontFamily: 'PokemonSolid'),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
