class Periksa {
  final int? id, statusCheckin, price;
  String? namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter,
      ruangan;

  Periksa({
    this.id,
    this.namaPasien,
    this.dokterSpesialis,
    this.jenisPerawatan,
    this.tanggalPeriksa,
    this.gambarDokter,
    this.ruangan,
    this.price,
    this.statusCheckin,
  });
}
