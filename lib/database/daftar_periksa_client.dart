import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'constant.dart';

class DaftarPeriksaClient {
  static const String endpoint = '/api/daftar_periksa';

  // mengambil semua data Periksa
  static Future<List<Periksa>> fetchAll(String id) async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)["data"];
      List<Periksa> listPeriksa = list.map((e) => Periksa.fromJson(e)).toList();

      listPeriksa.removeWhere((periksa) => periksa.idUser != int.parse(id));
      return listPeriksa;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // show Periksa berdasarkan ID
  static Future<Periksa> show(String id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Periksa.fromJson(jsonDecode(response.body)["data"]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // add data Periksa
  static Future<Response> addPeriksa(Periksa periksa, String userID) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          periksa.toJson()..addAll({"id_user": userID}),
        ),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // update data Periksa
  static Future<Response> update(Periksa periksa, String userID) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${periksa.id}'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(
            periksa.toJson()..addAll({"id_user": userID}),
          )).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updateStatus(int id) async {
    try {
      var response = await post(
        Uri.http(url, '$endpoint/updateStatus'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "id": id,
          },
        ),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // update/simpan rating dan ulasan object periksa tertentu dari list yang dipilih
  static Future<Response> saveRatingUlasan(Periksa periksaToRating) async {
    try {
      var response = await post(
        Uri.http(url, '$endpoint/updateRatingUlasan'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          periksaToRating.toJson(),
        ),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // hapus ulasan
  static Future<Response> hapusUlasan(String idPeriksa) async {
    try {
      var response =
          await put(Uri.http(url, '$endpoint/hapusUlasan/$idPeriksa'));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // hapus data Periksa
  static Future<Response> destroy(String id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
