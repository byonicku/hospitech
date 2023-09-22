import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/view/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterView(),
    );
  }
}
