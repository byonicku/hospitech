import 'package:flutter/material.dart';

const fontSizeConstantBig = 30.0;
const fontSizeOrdinary = 18.0;

var buildExpandedGrid = (title, descriptionText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeConstantBig,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              descriptionText,
              style: const TextStyle(
                fontSize: fontSizeOrdinary,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
};
