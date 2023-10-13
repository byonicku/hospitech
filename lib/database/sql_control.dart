import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';

Future<void> addUser(User user) async {
  await SQLHelper.addUser(user.username!, user.email!, user.password!,
      user.noTelp!, user.tglLahir!, user.jenisKelamin!);
}

Future<void> editUser(User user) async {
  await SQLHelper.editUser(user.id!, user.username!, user.email!,
      user.password!, user.noTelp!, user.tglLahir!, user.jenisKelamin!);
}

Future<void> deleteUser(User user) async {
  await SQLHelper.deleteUser(user.id!);
}

Future<void> getUser() async {
  final data = await SQLHelper.getUser();
  print(data);
}

Future<bool> checkEmail(String? email) async {
  final bool data = await SQLHelper.checkEmail(email);
  return data;
}

Future<bool> checkLogin(String? username, String? password) async {
  final bool data = await SQLHelper.checkLogin(username, password);
  return data;
}
