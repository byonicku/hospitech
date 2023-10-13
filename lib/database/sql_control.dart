import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

// Add data into database
Future<void> addUser(User user) async {
  await SQLHelper.addUser(user.username!, user.email!, user.password!,
      user.noTelp!, user.tglLahir!, user.jenisKelamin!);
}

Future<void> addDaftarPeriksa(Periksa periksa) async {
  await SQLHelper.addDaftarPeriksa(periksa.namaPasien!, periksa.dokterSpesialis!,
      periksa.jenisPerawatan!, periksa.tanggalPeriksa!, periksa.gambarDokter!);
}

// Edit data in database
Future<void> editUser(User user) async {
  await SQLHelper.editUser(user.id!, user.username!, user.email!,
      user.password!, user.noTelp!, user.tglLahir!, user.jenisKelamin!);
}

// Delete data in database
Future<void> deleteUser(User user) async {
  await SQLHelper.deleteUser(user.id!);
}

// Getting data from database
Future<void> getUser() async {
  final data = await SQLHelper.getUser();
  print(data);
}

Future<void> getDaftarPeriksa() async {
  final data = await SQLHelper.getDaftarPeriksa();
  print(data);
}

// Checking data with data in database
Future<bool> checkEmail(String? email) async {
  final bool data = await SQLHelper.checkEmail(email);
  return data;
}

Future<bool> checkUsername(String? username) async {
  final bool data = await SQLHelper.checkUsername(username);
  return data;
}

Future<bool> checkLogin(String? username, String? password) async {
  final bool data = await SQLHelper.checkLogin(username, password);
  return data;
}
