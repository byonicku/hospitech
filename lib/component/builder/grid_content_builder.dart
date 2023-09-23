import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/builder/top_left_icon.dart';

const topLeftIconRadius = 20.0;
const fontSizeConstant = 22.0;

var buildGridContent = (imageAssetPath, title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          topLeftIcon(topLeftIconRadius, imageAssetPath),
        ],
      ),
      Expanded(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSizeConstant,
              ),
            ),
          ),
        ),
      ),
    ],
  );
};
