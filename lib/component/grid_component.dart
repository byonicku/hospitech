import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/builder/grid_content_builder.dart';

List<Widget> getListOfGridContent() {
  List<Widget> listOfGridContent = [];

  listOfGridContent.addAll([
    buildGridContent("assets/images/topLeftIcon1.png", "Gigi"),
    buildGridContent("assets/images/topLeftIcon2.png", "Jantung"),
    buildGridContent("assets/images/topLeftIcon3.png", "Mata"),
    buildGridContent("assets/images/topLeftIcon4.png", "Paru - Paru"),
    buildGridContent("assets/images/topLeftIcon5.png", "Radiologi"),
    buildGridContent("assets/images/topLeftIcon6.png", "Neurologi"),
    buildGridContent("assets/images/topLeftIcon7.png", "Ortopedi"),
    buildGridContent("assets/images/topLeftIcon8.png", "Urologi"),
  ]);

  return listOfGridContent;
}
