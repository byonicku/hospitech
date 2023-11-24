import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/edit_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/tambah_periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/daftar_periksa_client.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/qr_scanner/scan_qr_page.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:uuid/uuid.dart';
import 'package:tugas_besar_hospital_pbp/invoice/pdf_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListPeriksaView extends StatefulWidget {
  const ListPeriksaView({super.key});

  @override
  State<ListPeriksaView> createState() => _ListPeriksaViewState();
}

class _ListPeriksaViewState extends State<ListPeriksaView> {
  List<Map<String, dynamic>> listPeriksaRaw = [];
  bool isDark = darkNotifier.value;
  String id = const Uuid().v1();

  void refresh() async {
    final dataPeriksa = await DaftarPeriksaClient.fetchAll();
    setState(() {
      listPeriksaRaw = dataPeriksa.map((periksa) => periksa.toJson()).toList();
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
          onTap: () {
            createPdf(listPeriksaRaw[index]['id_periksa'], id, context);
            setState(() {
              const uuid = Uuid();
              id = uuid.v1();
            });
          },
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
    final orientation = MediaQuery.of(context).orientation;
    final deviceSize = MediaQuery.of(context).size;
    final imageWidth =
        deviceSize.width * ((orientation == Orientation.portrait) ? 0.2 : 0.07);

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
          Text('Nama Dokter', style: TextStyle(fontSize: 14.sp)),
          Text(
            periksa['dokter_spesialis'],
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
          Text(periksa['jenis_perawatan'],
              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          Text('Tanggal Periksa: ${periksa['tanggal_periksa']}',
              style: TextStyle(color: Colors.black, fontSize: 14.sp)),
          Text('Ruangan: ${periksa['ruangan']}',
              style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 0.5.h),
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
        minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
      ),
      child:
          Text('Edit', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
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

                  // deleteDaftarPeriksa(idHapus);
                  DaftarPeriksaClient.destroy(idHapus);

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
        minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
      ),
      child: Text('Delete',
          style: TextStyle(color: Colors.white, fontSize: 14.sp)),
    );
  }

  Widget buildCheckInButton(Map<String, dynamic> periksa, int index) {
    if (listPeriksaRaw[index]['status_checkin'] == 1) {
      return ElevatedButton(
          onPressed: null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
          ),
          child: Text('Check In',
              style: TextStyle(color: Colors.white, fontSize: 14.sp)));
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
          minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
        ),
        child: Text('Check In',
            style: TextStyle(color: Colors.white, fontSize: 14.sp)),
      );
    }
  }

  Widget buildEditDeleteButtons(Map<String, dynamic> periksa, int index) {
    return Row(
      children: [
        buildEditButton(periksa, index),
        SizedBox(width: 1.5.w),
        buildDeleteButton(periksa, index),
        SizedBox(width: 1.5.w),
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
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
            )
          : Center(
              child: Text("Daftar Periksa Kosong",
                  style: TextStyle(fontSize: 14.sp)),
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
