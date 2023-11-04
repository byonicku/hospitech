import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/edit_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/tambah_periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/qr_scanner/scan_qr_page.dart';
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

  Widget buildPeriksaCard(Map<String, dynamic> periksa, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              buildDokterInfo(periksa),
              buildPeriksaInfo(periksa, index: index),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDokterInfo(Map<String, dynamic> periksa) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final deviceSize = MediaQuery.of(context).size;
    final imageWidth = deviceSize.width * 0.2;

    return SizedBox(
      width: deviceSize.width * 0.25,
      height: deviceSize.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              periksa['gambar_dokter'],
              width: imageWidth,
              height: imageWidth,
              cacheWidth: (300 * devicePixelRatio).round(),
              filterQuality: FilterQuality.none,
              fit: BoxFit.cover,
            ),
          ),
          const Text('Nama Dokter', style: TextStyle(fontSize: 12)),
          Text(
            periksa['dokter_spesialis'],
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildPeriksaInfo(Map<String, dynamic> periksa, {int? index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(periksa['nama_pasien'],
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          Text(periksa['jenis_perawatan'],
              style: const TextStyle(color: Colors.grey)),
          Text('Tanggal Periksa: ${periksa['tanggal_periksa']}'),
          Text('Ruangan: ${periksa['ruangan']}'),
          buildEditDeleteButtons(
            periksa,
            index!,
          ),
        ],
      ),
    );
  }

  Widget buildEditButton(Map<String, dynamic> periksa, int index) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditPeriksaView(
              id: listPeriksaRaw[index]['id_periksa'],
              namaPasien: listPeriksaRaw[index]['nama_pasien'],
              dokterSpesialis: listPeriksaRaw[index]['dokter_spesialis'],
              jenisPerawatan: listPeriksaRaw[index]['jenis_perawatan'],
              tanggalPeriksa: listPeriksaRaw[index]['tanggal_periksa'],
              gambarDokter: listPeriksaRaw[index]['gambar_dokter'],
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        minimumSize: MaterialStateProperty.all(const Size(20, 35)),
      ),
      child: const Text('Edit', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildDeleteButton(Map<String, dynamic> periksa, int index) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final namaPasienHapus = listPeriksaRaw[index]['nama_pasien'];

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Konfirmasi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
                'Apakah yakin ingin menghapus data pasien $namaPasienHapus?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Menghapus Data Yang di pilih
                  final idHapus = listPeriksaRaw[index]['id_periksa'];

                  deleteDaftarPeriksa(idHapus);

                  Navigator.pop(context);

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Berhasil Menghapus Data'),
                    ),
                  );

                  refresh();
                },
                child: Text('Ya',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Batal Menghapus Data'),
                    ),
                  );
                },
                child: Text(
                  'Tidak',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        minimumSize: MaterialStateProperty.all(const Size(20, 35)),
      ),
      child: const Text('Delete', style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildCheckInButton(Map<String, dynamic> periksa, int index) {
    if (listPeriksaRaw[index]['status_checkin'] == 1) {
      return ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
          minimumSize: MaterialStateProperty.all(const Size(20, 35)),
        ),
        child: const Text('Check In'),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BarcodeScannerPageView(
                id: listPeriksaRaw[index]['id_periksa'],
                namaPasien: listPeriksaRaw[index]['nama_pasien'],
                dokterSpesialis: listPeriksaRaw[index]['dokter_spesialis'],
                jenisPerawatan: listPeriksaRaw[index]['jenis_perawatan'],
                tanggalPeriksa: listPeriksaRaw[index]['tanggal_periksa'],
                gambarDokter: listPeriksaRaw[index]['gambar_dokter'],
                ruang: listPeriksaRaw[index]['ruangan'],
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          minimumSize: MaterialStateProperty.all(const Size(20, 35)),
        ),
        child: const Text('Check In', style: TextStyle(color: Colors.white)),
      );
    }
  }

  Widget buildEditDeleteButtons(Map<String, dynamic> periksa, int index) {
    return Row(
      children: [
        buildEditButton(periksa, index),
        const SizedBox(width: 4),
        buildDeleteButton(periksa, index),
        const SizedBox(width: 4),
        buildCheckInButton(periksa, index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Periksa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: listPeriksaRaw.isNotEmpty
          ? ListView.separated(
              itemCount: listPeriksaRaw.length,
              itemBuilder: (context, index) {
                final periksa = listPeriksaRaw[index];
                return buildPeriksaCard(periksa, index);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
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
                gambarDokter: null,
                ruangan: null,
              ),
            ),
          );
        },
        tooltip: "Tambah Periksa",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
