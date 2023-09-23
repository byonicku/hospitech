import 'package:flutter/material.dart';

var topLeftIcon = (topLeftIconRadius, imagePath) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.all(7.0),
      child: CircleAvatar(
        radius: topLeftIconRadius,
        backgroundImage: AssetImage(imagePath),
        backgroundColor: Colors.white,
      ),
    ),
  );
};
