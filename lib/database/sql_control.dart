import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

// Add data into database
Future<void> addUser(User user) async {
  await SQLHelper.addUser(user.username!, user.email!, user.password!,
      user.noTelp!, user.tglLahir!, user.jenisKelamin!);
}

Future<void> addDaftarPeriksa(Periksa periksa) async {
  await SQLHelper.addDaftarPeriksa(
      periksa.namaPasien!,
      periksa.dokterSpesialis!,
      periksa.jenisPerawatan!,
      periksa.tanggalPeriksa!,
      periksa.gambarDokter!,
      periksa.price!,
      periksa.ruangan!);
}

// Edit data in database
Future<void> editUser(User user) async {
  await SQLHelper.editUser(
      user.id!,
      user.username!,
      user.email!,
      user.password!,
      user.noTelp!,
      user.tglLahir!,
      user.jenisKelamin!,
      user.profilePhoto!);
}

Future<void> editPeriksa(Periksa dataPeriksa) async {
  await SQLHelper.editDaftarPeriksa(
      dataPeriksa.id!,
      dataPeriksa.namaPasien!,
      dataPeriksa.dokterSpesialis!,
      dataPeriksa.jenisPerawatan!,
      dataPeriksa.tanggalPeriksa!,
      dataPeriksa.gambarDokter!,
      dataPeriksa.ruangan!,
      dataPeriksa.price!,
      dataPeriksa.statusCheckin!);
}

// Delete data in database
Future<void> deleteUser(User user) async {
  await SQLHelper.deleteUser(user.id!);
}

Future<void> deleteDaftarPeriksa(int id) async {
  await SQLHelper.deleteDaftarPeriksa(id);
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

Future<List<Map<String, dynamic>>> getID(
    String? username, String? password) async {
  return await SQLHelper.getID(username, password);
}

Future<User> getUserByID(int? id) async {
  return SQLHelper.getUserByID(id);
}

Future<void> updateUserByID(int? id, User? user) async {
  Map<String, dynamic> data = {
    'id': user!.id,
    'username': user.username,
    'email': user.email,
    'password': user.password,
    'no_telp': user.noTelp,
    'tanggal_lahir': user.tglLahir,
    'jenis_kelamin': user.jenisKelamin
  };

  await SQLHelper.updateUserByID(id, data);
}

Future<Periksa> getPeriksaByID(int? id) async {
  return await SQLHelper.getPeriksaByID(id);
}
