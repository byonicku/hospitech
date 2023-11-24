import 'dart:convert';

class Periksa {
  final int? id, statusCheckin;
  String? namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter,
      ruangan;

  Periksa(
      {this.id,
      this.namaPasien,
      this.dokterSpesialis,
      this.jenisPerawatan,
      this.tanggalPeriksa,
      this.gambarDokter,
      this.ruangan,
      this.statusCheckin});

  // mengubah JSON data dari API menjadi objek Periksa
  factory Periksa.fromRawJson(String str) => Periksa.fromJson(json.decode(str));
  factory Periksa.fromJson(Map<String, dynamic> json) => Periksa(
        id: json["id_daftar_periksa"],
        namaPasien: json["nama_pasien"],
        dokterSpesialis: json["dokter_spesialis"],
        jenisPerawatan: json["jenis_perawatan"],
        gambarDokter: json["gambar_dokter"],
        ruangan: json["ruangan"],
        tanggalPeriksa: json["tanggal_periksa"],
        statusCheckin: json["status_checkin"],
      );

  // mengubah objek Periksa menjadi data JSON untuk dikirmkan ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id_daftar_periksa": id,
    "nama_pasien": namaPasien,
    "dokter_spesialis": dokterSpesialis,
    "jenis_perawatan": jenisPerawatan,
    "gambar_dokter": gambarDokter,
    "ruangan": ruangan,
    "tanggal_periksa": tanggalPeriksa,
    "status_checkin": statusCheckin,
  };
}
