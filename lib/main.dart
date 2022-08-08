import 'package:flutter/material.dart';
import 'package:sudoku/screens/game.dart';
import 'package:sudoku/screens/home.dart';

void main() {
  runApp(MaterialApp(
    title: "Sudoku App",
    theme: ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const Homepage(),
      '/game': (context) => const Game(),
    },
  ));
}
