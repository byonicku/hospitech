import 'package:flutter/material.dart';

Padding inputLogin(Function(String?) validasi,
    {required TextEditingController controller,
    required String hintTxt,
    required IconData iconData,
    bool password = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0),
    child: TextFormField(
      validator: (value) => validasi(value),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintTxt,
        border: const OutlineInputBorder(),
        icon: Icon(iconData),
      ),
    ),
  );
}
