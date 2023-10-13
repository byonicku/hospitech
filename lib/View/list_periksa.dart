import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/edit_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/tambah_periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';

class ListPeriksaView extends StatefulWidget {
  const ListPeriksaView({super.key});

  @override
  State<ListPeriksaView> createState() => _ListPeriksaViewState();
}

class _ListPeriksaViewState extends State<ListPeriksaView> {
  List<Map<String, dynamic>> listPeriksaRaw = [];
  bool isDark = darkNotifier.value;

  void refresh() async {
    final dataPeriksa = await SQLHelper.getDaftarPeriksa();
    setState(() {
      listPeriksaRaw = dataPeriksa;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Periksa'),
      ),
      body: listPeriksaRaw.isNotEmpty
          ? ListView.builder(
              itemCount: listPeriksaRaw.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Image.asset(
                                      listPeriksaRaw[index]['gambar_dokter'],
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Nama Dokter',
                                    ),
                                    Text(
                                      listPeriksaRaw[index]['dokter_spesialis'],
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(height: 5),
                                      // Nama Pasien
                                      Text(
                                        listPeriksaRaw[index]['nama_pasien'],
                                      ),
                                      Container(height: 5),
                                      Text(
                                        listPeriksaRaw[index]
                                            ['jenis_perawatan'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      Container(height: 10),
                                      // Tanggal periksa
                                      // ignore: prefer_interpolation_to_compose_strings
                                      Text('Tanggal Periksa : ' +
                                          listPeriksaRaw[index]
                                              ['tanggal_periksa']),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              final scaffoldMessenger =
                                                  ScaffoldMessenger.of(context);

                                              final namaPasienHapus =
                                                  listPeriksaRaw[index]
                                                      ['nama_pasien'];

                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: const Text(
                                                            'Konfirmasi',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        content: Text(
                                                            'Apakah yakin ingin menghapus data pasien $namaPasienHapus?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              // Menghapus Data Yang di pilih
                                                              final idHapus =
                                                                  listPeriksaRaw[
                                                                          index]
                                                                      [
                                                                      'id_periksa'];

                                                              deleteDaftarPeriksa(
                                                                  idHapus);

                                                              Navigator.pop(
                                                                  context);

                                                              scaffoldMessenger
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  content: Text(
                                                                      'Berhasil Menghapus Data'),
                                                                ),
                                                              );

                                                              refresh();
                                                            },
                                                            child: Text('Ya',
                                                                style: TextStyle(
                                                                    color: isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              scaffoldMessenger
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  content: Text(
                                                                      'Batal Menghapus Data'),
                                                                ),
                                                              );
                                                            },
                                                            child: Text('Tidak',
                                                                style: TextStyle(
                                                                    color: isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 197, 13, 0),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                          Container(width: 5),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => EditPeriksaView(
                                                      id: listPeriksaRaw[index]
                                                          ['id_periksa'],
                                                      namaPasien:
                                                          listPeriksaRaw[index]
                                                              ['nama_pasien'],
                                                      dokterSpesialis:
                                                          listPeriksaRaw[index][
                                                              'dokter_spesialis'],
                                                      jenisPerawatan:
                                                          listPeriksaRaw[index][
                                                              'jenis_perawatan'],
                                                      tanggalPeriksa:
                                                          listPeriksaRaw[index][
                                                              'tanggal_periksa'],
                                                      gambarDokter:
                                                          listPeriksaRaw[index]
                                                              ['gambar_dokter']),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Edit'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("Daftar Periksa Kosong"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPeriksa(
                  id: null,
                  namaPasien: null,
                  dokterSpesialis: null,
                  jenisPerawatan: null,
                  tanggalPeriksa: null,
                  gambarDokter: null),
            ),
          );
        },
        tooltip: "Tambah Periksa",
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
