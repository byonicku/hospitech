import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';

AlertDialog alert(BuildContext context, Map? data) {
  bool isDark = darkNotifier.value;

  return AlertDialog(
    title:
        const Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold)),
    content: const Text('Apakah data Anda sudah benar?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LoginView(
                      data: data,
                    )),
          );
        },
        child: Text('Sudah',
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Belum',
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
