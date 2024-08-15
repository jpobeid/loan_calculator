import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MaterialApp(
    home: const HomePage(),
    theme: ThemeData(
      textTheme: const TextTheme(
        labelSmall: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 22),
      ),
    ),
  ));
}
