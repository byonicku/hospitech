import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/builder/GridExpandedBuilder.dart';

List<Widget> getListOfExpandedGrid() {
  List<Widget> listOfExpandedGrid = [];

  listOfExpandedGrid.addAll([
    buildExpandedGrid(
        "Gigi", "Dokter spesialis gigi adalah dokter yang menangani gigi"),
    buildExpandedGrid("Jantung",
        "Dokter spesialis jantung adalah dokster yang menangani jantung"),
    buildExpandedGrid(
        "Mata", "Dokter spesialis mata adalah dokter yang menangani mata"),
    buildExpandedGrid("Paru - paru",
        "Dokter spesialis Paru - paru adalah dokter yang menangani Paru - paru"),
    buildExpandedGrid("Radiologi",
        "Dokter spesialis Radiologi adalah dokter yang menangani Radiolog"),
    buildExpandedGrid("Neurologi",
        "Dokter spesialis Neurologi adalah dokter yang menangani Neurolog"),
    buildExpandedGrid("Ortopedi",
        "Dokter spesialis Ortopedi adalah dokter yang menangani Ortopedi"),
    buildExpandedGrid("Urologi",
        "Dokter spesialis Urologi adalah dokter yang menangani Urologi"),
  ]);

  return listOfExpandedGrid;
}
