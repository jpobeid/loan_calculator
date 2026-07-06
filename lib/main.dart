import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const HomePage(),
        theme: ThemeData(
          textTheme: const TextTheme(
            labelSmall: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 22),
          ),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(iconSize: WidgetStateProperty.all(32))),
        ),
      ),
    ),
  );
}
