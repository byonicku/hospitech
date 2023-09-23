import 'package:flutter/material.dart';

Padding inputForm(Function(String?) validasi,
    {required TextEditingController controller,
    required String hintTxt,
    required String labelTxt,
    required IconData iconData,
    bool password = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: SizedBox(
        width: 360,
        child: TextFormField(
          validator: (value) => validasi(value),
          autofocus: true,
          controller: controller,
          obscureText: password,
          decoration: InputDecoration(
              labelText: labelTxt,
              hintText: hintTxt,
              border: const OutlineInputBorder(),
              icon: Icon(iconData)),
        )),
  );
}
