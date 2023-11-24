import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';

import 'dart:convert';
import 'package:http/http.dart';

class DaftarPeriksaClient {
  static const String url = '10.0.2.2:8000';
  static const String endpoint = '/api/daftar_periksa';

  // mengambil semua data Periksa
  static Future<List<Periksa>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)["data"];

      return list.map((e) => Periksa.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // show Periksa berdasarkan ID (ini gatau perlu apa engga)
  static Future<Periksa> show(String id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Periksa.fromJson(jsonDecode(response.body)["data"]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // add data Periksa
  static Future<Response> addPeriksa(Periksa periksa) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: periksa.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // update data Periksa
  static Future<Response> update(Periksa periksa) async {
    try {
      var response = await put(
        Uri.http(url, '$endpoint/${periksa.id}'),
        headers: {"Content-Type": "application/json"},
        body: periksa.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // hapus data Periksa
  static Future<Response> destroy(String id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
