import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

int getPPNTotal(Periksa periksa) {
  int ppn = periksa.price! * 10 ~/ 100;
  return ppn;
}

int getTotal(Periksa periksa) {
  int total = periksa.price! + (periksa.price! * 10 ~/ 100);
  return total;
}