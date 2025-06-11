import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';

import 'constant.dart';

class UserClient {
  static const String endpoint = '/api/api/user';

  // mengambil semua data user (kayaknya ga perlu soalnya ngapain kan get all user di aplikasi wkwk)
  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint))
          .timeout(const Duration(seconds: 5));

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
      var response = await get(Uri.https(url, '$endpoint/$id'))
          .timeout(const Duration(seconds: 5));

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
        Uri.https(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: user.toRawJson(),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // check login data user
  static Future<User> login(String username, String password) async {
    try {
      print('Attempting to connect to: $url$endpoint/login');

      var response = await post(Uri.https(url, '$endpoint/login'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": username,
            "password": password,
          })).timeout(const Duration(seconds: 5));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) throw Exception(response.body);

      var responseData = json.decode(response.body);
      if (responseData["data"] == null) {
        throw Exception("Invalid response format: data field is null");
      }

      User loggedInUser = User.fromJson(responseData["data"]);

      return loggedInUser;
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  // update profile user
  static Future<Response> update(User user) async {
    try {
      var response = await put(
        Uri.https(url, '$endpoint/${user.id}'),
        headers: {"Content-Type": "application/json"},
        body: user.toRawJson(),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updatePassword(
      String username, String password, String newPassword) async {
    try {
      var response = await post(Uri.https(url, '$endpoint/updatePass'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "username": username,
            "passwordLama": password,
            "passwordBaru": newPassword,
          })).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)["message"]);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updatePhotoProfil(
      int? id, String profilePhoto) async {
    try {
      var response = await post(Uri.https(url, '$endpoint/updatePfp'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "id": id,
            "profile_photo": profilePhoto,
          })).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)["message"]);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
