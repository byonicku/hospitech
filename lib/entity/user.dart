import 'dart:convert';

class User {
  final int? id;
  String? username,
      email,
      password,
      noTelp,
      tglLahir,
      jenisKelamin,
      profilePhoto;

  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.noTelp,
      this.tglLahir,
      this.jenisKelamin,
      this.profilePhoto});

  // menerima data JSON dari API dan diconvert jadi objek User
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id_user"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        noTelp: json["no_telp"],
        tglLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        profilePhoto: json["profile_photo"],
      );

  // membuat data json dari objek User untuk dikirimkan melalui API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "no_telp": noTelp,
        "tanggal_lahir": tglLahir,
        "jenis_kelamin": jenisKelamin,
        "profile_photo": profilePhoto,
      };
}
