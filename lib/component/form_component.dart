import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Padding inputForm(Function(String?) validasi,
    {required TextEditingController controller,
    required String hintTxt,
    required String labelTxt,
    required IconData iconData,
    TextInputType? textInputType,
    bool password = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
    child: SizedBox(
        width: 100.w,
        child: TextFormField(
          validator: (value) => validasi(value),
          autofocus: false,
          controller: controller,
          obscureText: password,
          keyboardType: textInputType,
          decoration: InputDecoration(
              labelText: labelTxt,
              hintText: hintTxt,
              border: const OutlineInputBorder(),
              icon: Icon(iconData)),
        )),
  );
}

Padding inputLogin(Function(String?) validasi,
    {required TextEditingController controller,
    required String hintTxt,
    required IconData iconData,
    bool password = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
    child: SizedBox(
      width: 100.w,
      child: TextFormField(
        validator: (value) => validasi(value),
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintTxt,
          border: const OutlineInputBorder(),
          icon: Icon(iconData),
        ),
      ),
    ),
  );
}
