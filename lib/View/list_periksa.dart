// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/detail_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/edit_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/tambah_periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/daftar_periksa_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/qr_scanner/scan_qr_page.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:uuid/uuid.dart';

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
          onTap: () {
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

            listPeriksaRaw[index]['status_checkin'] == 1
                ? listPeriksaRaw[index]['rating'] == 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPeriksaView(
                              selectedPeriksa: Periksa(
                            id: listPeriksaRaw[index]['id_daftar_periksa'],
                            namaPasien: listPeriksaRaw[index]['nama_pasien'],
                            dokterSpesialis: listPeriksaRaw[index]
                                ['dokter_spesialis'],
                            gambarDokter: listPeriksaRaw[index]
                                ['gambar_dokter'],
                            idUser: listPeriksaRaw[index]['id_user'],
                            jenisPerawatan: listPeriksaRaw[index]
                                ['jenis_perawatan'],
                            price: listPeriksaRaw[index]['price'],
                            rating: listPeriksaRaw[index]['rating'],
                            ruangan: listPeriksaRaw[index]['ruangan'],
                            statusCheckin: listPeriksaRaw[index]
                                ['status_checkin'],
                            tanggalPeriksa: listPeriksaRaw[index]
                                ['tanggal_periksa'],
                            ulasan: listPeriksaRaw[index]['ulasan'],
                          )),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPeriksaView(
                            selectedPeriksa: Periksa(
                                id: listPeriksaRaw[index]['id_daftar_periksa'],
                                namaPasien: listPeriksaRaw[index]
                                    ['nama_pasien'],
                                dokterSpesialis: listPeriksaRaw[index]
                                    ['dokter_spesialis'],
                                gambarDokter: listPeriksaRaw[index]
                                    ['gambar_dokter'],
                                idUser: listPeriksaRaw[index]['id_user'],
                                jenisPerawatan: listPeriksaRaw[index]
                                    ['jenis_perawatan'],
                                price: listPeriksaRaw[index]['price'],
                                rating: listPeriksaRaw[index]['rating'],
                                ruangan: listPeriksaRaw[index]['ruangan'],
                                statusCheckin: listPeriksaRaw[index]
                                    ['status_checkin'],
                                tanggalPeriksa: listPeriksaRaw[index]
                                    ['tanggal_periksa'],
                                ulasan: listPeriksaRaw[index]['ulasan']),
                          ),
                        ),
                      )
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content:
                          Text('Anda harus check in untuk memberikan rating'),
                    ),
                  );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDokterInfo(periksa),
              listPeriksaRaw[index]['status_checkin'] == 0
                  ? buildPeriksaInfo(periksa, index: index)
                  : buildPeriksaInfo2(periksa, index: index),
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

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.4.h),
      child: SizedBox(
        width: 24.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
      ),
    );
  }

  // PERIKSA INFO WIDGET =======================================================================================================================
  Widget buildPeriksaInfo(Map<String, dynamic> periksa, {int? index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(periksa['nama_pasien'],
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    Text(periksa['jenis_perawatan'],
                        style: TextStyle(fontSize: 14.sp)),
                    Text('${periksa['ruangan']}',
                        style: TextStyle(fontSize: 14.sp)),
                    Text('Tanggal Periksa : ${periksa['tanggal_periksa']}',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 3.0.w, bottom: 4.h),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: MaterialStateProperty.all(
                        listPeriksaRaw[index!]['status_checkin'] == 1
                            ? Colors.green
                            : Colors.amber),
                    minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
                  ),
                  child: Text(
                    listPeriksaRaw[index]['status_checkin'] == 1
                        ? 'Selesai'
                        : 'Pending',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          buildShowRating(periksa, index),
          buildEditDeleteButtons(periksa, index),
        ],
      ),
    );
  }

  Widget buildPeriksaInfo2(Map<String, dynamic> periksa, {int? index}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(periksa['nama_pasien'],
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500)),
                    Text(periksa['jenis_perawatan'],
                        style: TextStyle(fontSize: 14.sp)),
                    Text('${periksa['ruangan']}',
                        style: TextStyle(fontSize: 14.sp)),
                    Text('Tanggal Periksa : ${periksa['tanggal_periksa']}',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 3.0.w, bottom: 3.h),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: MaterialStateProperty.all(
                        listPeriksaRaw[index!]['status_checkin'] == 1
                            ? Colors.green
                            : Colors.amber),
                    minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
                  ),
                  child: Text(
                    listPeriksaRaw[index]['status_checkin'] == 1
                        ? 'Selesai'
                        : 'Pending',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          buildShowRating(periksa, index),
        ],
      ),
    );
  }

  // EDIT BUTTON WIDGET =======================================================================================================================
  Widget buildEditButton(Map<String, dynamic> periksa, int index) {
    return ElevatedButton(
      key: Key('EditBtn'),
      onPressed: listPeriksaRaw[index]['status_checkin'] == 0
          ? () {
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
                    rating: listPeriksaRaw[index]['rating'],
                    ulasan: listPeriksaRaw[index]['ulasan'],
                  ),
                ),
              );
            }
          : () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content:
                      Text('Anda tidak bisa mengedit data setelah check in'),
                ),
              ),
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
                onPressed: listPeriksaRaw[index]['status_checkin'] == 0
                    ? () async {
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
                      }
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Anda tidak bisa menghapus data setelah check in'),
                          ),
                        ),
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
    return listPeriksaRaw[index]['status_checkin'] == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildEditButton(periksa, index),
              buildDeleteButton(periksa, index),
              buildCheckInButton(periksa, index),
            ],
          )
        : Row();
  }

  // SHOW RATING WIDGET
  Widget buildShowRating(Map<String, dynamic> periksa, int index) {
    bool rating = listPeriksaRaw[index]['rating'] != 0;

    return Row(
      children: [
        Icon(
          Icons.star,
          color: rating ? Colors.amber : Colors.grey,
        ),
        Text(
          rating
              ? '${listPeriksaRaw[index]["rating"]} out of 5'
              : 'Belum diberi rating',
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
