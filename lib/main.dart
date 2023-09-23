import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';

void main() {
  runApp(const MainApp());
}

final darkNotifier = ValueNotifier<bool>(false);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkNotifier,
        builder: (BuildContext context, bool isDark, Widget? child) {
          return MaterialApp(
            title: "Hospital PBP",
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: LoginView(),
          );
        });
  }
}
