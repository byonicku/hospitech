import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/home_grid.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          secondary: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.black,
          onBackground: Colors.black,
          surface: Colors.black,
          onSurface: Colors.black
        ),
      ),
      home: HomeGrid(),
    );
  }
}
