import 'package:flutter/material.dart';
import 'package:sudoku/screens/home.dart';
import 'package:sudoku/screens/sudoku.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
      '/sudoku': (context) => const Sudoku(),
    },
  ));
}
