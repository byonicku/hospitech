import 'package:tugas_besar_hospital_pbp/entity/user.dart';

import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  static const String url = '10.0.2.2:8000';
  static const String endpoint = '/api/user';

  // mengambil semua data user (kayaknya ga perlu soalnya ngapain kan get all user di aplikasi wkwk)
  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)["data"];

      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // show user profile
  static Future<User> show(String id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(jsonDecode(response.body)["data"]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // register data user
  static Future<Response> register(User user) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: user.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // check login data user
  static Future<User> login(String username, String password) async {
    try {
      var response = await post(Uri.http(url, '$endpoint/login'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": username,
            "password": password,
          }));

      if (response.statusCode != 200) throw Exception(response.body);

      User loggedInUser = User.fromJson(json.decode(response.body)["data"]);

      return loggedInUser;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // update profile user
  static Future<Response> update(User user) async {
    try {
      var response = await put(
        Uri.http(url, '$endpoint/${user.id}'),
        headers: {"Content-Type": "application/json"},
        body: user.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updatePassword(
      String username, String password, String newPassword) async {
    try {
      var response = await post(Uri.http(url, '$endpoint/updatePass'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": username,
            "passwordLama": password,
            "passwordBaru": newPassword,
          }));

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)["message"]);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
