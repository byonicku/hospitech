import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/builder/grid_expanded_builder.dart';

List<Widget> getListOfExpandedGrid() {
  List<Widget> listOfExpandedGrid = [];

  listOfExpandedGrid.addAll([
    buildExpandedGrid(
        "Gigi", "Dokter spesialis gigi adalah dokter yang menangani Gigi"),
    buildExpandedGrid("Jantung",
        "Dokter spesialis jantung adalah dokster yang menangani Jantung"),
    buildExpandedGrid(
        "Mata", "Dokter spesialis mata adalah dokter yang menangani Mata"),
    buildExpandedGrid("Paru - paru",
        "Dokter spesialis Paru - paru adalah dokter yang menangani Paru - paru"),
    buildExpandedGrid("Radiologi",
        "Dokter spesialis Radiologi adalah dokter yang menangani Radiologi"),
    buildExpandedGrid("Neurologi",
        "Dokter spesialis Neurologi adalah dokter yang menangani Neurologi/Syaraf"),
    buildExpandedGrid("Ortopedi",
        "Dokter spesialis Ortopedi adalah dokter yang menangani Ortopedi/Tulang"),
    buildExpandedGrid("Urologi",
        "Dokter spesialis Urologi adalah dokter yang menangani Urologi"),
    buildExpandedGrid("Hepatologi",
        "Dokter spesialis Hepatologi adalah dokter yang menangani Hepatologi/Hati"),
    buildExpandedGrid("Pendengaran",
        "Dokter spesialis Pendengaran adalah dokter yang menangani Pendengaran")
  ]);

  return listOfExpandedGrid;
}
