// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
import 'package:shared_preferences/shared_preferences.dart';

class ListPeriksaView extends StatefulWidget {
  const ListPeriksaView({super.key});

  @override
  State<ListPeriksaView> createState() => _ListPeriksaViewState();
}

class _ListPeriksaViewState extends State<ListPeriksaView> {
  List<Map<String, dynamic>> listPeriksaRaw = [];
  bool isDark = darkNotifier.value;
  String id = const Uuid().v1();
  bool _isLoading = true;
  String status = 'Tidak ada data periksa';

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id') ?? '';

    setState(() {
      _isLoading = true;
    });

    final dataPeriksa = await DaftarPeriksaClient.fetchAll(id).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        setState(() {
          _isLoading = false;
          status = 'Tidak ada koneksi internet';
        });
        return [];
      },
    );

    setState(() {
      listPeriksaRaw = dataPeriksa.map((periksa) => periksa.toJson()).toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  // MAIN PERIKSA CARD WIDGET =======================================================================================================================
  Widget buildPeriksaCard(Map<String, dynamic> periksa, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        elevation: 1,
        child: InkWell(
          onTap: () async {
            // await createPdf(
            //     listPeriksaRaw[index]['id_daftar_periksa'], id, context);

            // setState(() {
            //   const uuid = Uuid();
            //   id = uuid.v1();
            //   _isLoading = true;
            // });

            // Future.delayed(const Duration(seconds: 1), () {
            //   setState(() {
            //     _isLoading = false;
            //   });
            // });
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

  // INFO DOKTER WIDGET =======================================================================================================================
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

  // PERIKSA INFO WIDGET =======================================================================================================================
  Widget buildPeriksaInfo(Map<String, dynamic> periksa, {int? index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(periksa['nama_pasien'],
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
              listPeriksaRaw[index!]['status'] != 1
                  ? Padding(
                      padding: EdgeInsets.only(right: 3.0.w),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                          minimumSize:
                              MaterialStateProperty.all(Size(5.w, 4.h)),
                        ),
                        child: Text(
                          'Pending',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(right: 3.0.w),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          minimumSize:
                              MaterialStateProperty.all(Size(5.w, 4.h)),
                        ),
                        child: Text(
                          'Selesai',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
            ],
          ),
          Text(periksa['jenis_perawatan'],
              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          Text('Tanggal Periksa: ${periksa['tanggal_periksa']}',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          Text('Ruangan: ${periksa['ruangan']}',
              style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 0.5.h),
          buildShowRating(periksa, index),
          buildEditDeleteButtons(
            periksa,
            index,
          ),
          cetakPdfButton(periksa, index)
        ],
      ),
    );
  }

  // EDIT BUTTON WIDGET =======================================================================================================================
  Widget buildEditButton(Map<String, dynamic> periksa, int index) {
    return ElevatedButton(
      key: Key('EditBtn'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditPeriksaView(
              id: listPeriksaRaw[index]['id_daftar_periksa'],
              namaPasien: listPeriksaRaw[index]['nama_pasien'],
              price: listPeriksaRaw[index]['price'],
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

  // DELETE BUTTON WIDGET =======================================================================================================================
  Widget buildDeleteButton(Map<String, dynamic> periksa, int index) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final namaPasienHapus = listPeriksaRaw[index]['nama_pasien'];

    return ElevatedButton(
      key: Key('DeleteBtn'),
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
                onPressed: () async {
                  // Menghapus Data Yang di pilih
                  try {
                    final int idHapus =
                        listPeriksaRaw[index]['id_daftar_periksa'];

                    await DaftarPeriksaClient.destroy(idHapus.toString());
                    refresh();

                    Navigator.of(context).pop();
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Berhasil Menghapus Data'),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Gagal Menghapus Data'),
                      ),
                    );
                  }
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

  // CHECK IN BUTTON WIDGET =======================================================================================================================
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
                id: listPeriksaRaw[index]['id_daftar_periksa'],
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

  // EDIT DELETE BUTTON WIDGET =======================================================================================================================
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

  // CETAK PDF BUTTON WIDGET =======================================================================================================================
  Widget cetakPdfButton(Map<String, dynamic> periksa, int index) {
    return ElevatedButton(
      key: Key('Cetak PDF Btn'),
      onPressed: () async {
        await createPdf(
            listPeriksaRaw[index]['id_daftar_periksa'], id, context);

        setState(() {
          const uuid = Uuid();
          id = uuid.v1();
          _isLoading = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
      ),
      child: Text(
        'Cetak PDF',
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }

  // SHOW RATING WIDGET
  Widget buildShowRating(Map<String, dynamic> periksa, int index) {
    return listPeriksaRaw[index]['rating'] != 0
        ? Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                '${listPeriksaRaw[index]["rating"]} out of 5',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        : Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.grey,
              ),
              Text(
                'Belum diberi rating',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Periksa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: !_isLoading
          ? (listPeriksaRaw.isNotEmpty
              ? ListView.separated(
                  itemCount: listPeriksaRaw.length,
                  itemBuilder: (context, index) {
                    final periksa = listPeriksaRaw[index];
                    return buildPeriksaCard(periksa, index);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                )
              : Center(
                  child: Text(status, style: TextStyle(fontSize: 14.sp)),
                ))
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPeriksa(
                id: null,
                namaPasien: null,
                price: null,
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
