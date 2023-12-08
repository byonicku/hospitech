// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tugas_besar_hospital_pbp/View/detail_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/database/daftar_periksa_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_helper.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:uuid/uuid.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditKomentarView extends StatefulWidget {
  final Periksa selectedPeriksa;

  const EditKomentarView({Key? key, required this.selectedPeriksa})
      : super(key: key);

  @override
  State<EditKomentarView> createState() => _EditKomentarViewState();
}

class _EditKomentarViewState extends State<EditKomentarView> {
  List<Map<String, dynamic>> listPeriksaRaw = [];
  bool isDark = darkNotifier.value;
  String idUUID = const Uuid().v1();
  bool _isLoading = true;
  String status = 'Tidak ada data periksa';
  SharedPreferences? prefs;
  String? id;
  double? inputRating;
  TextEditingController komentarController = TextEditingController();

  void refresh() async {
    setState(() {
      _isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    id = prefs!.getString('id') ?? '';

    if (widget.selectedPeriksa.ulasan != '-') {
      komentarController.text = widget.selectedPeriksa.ulasan!;

      setState(() {
        inputRating = widget.selectedPeriksa.rating!.toDouble();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  // BUILD DETAIL PERIKSA
  Widget buildDetailPeriksa() {
    return Padding(
      padding: EdgeInsets.only(left: 7.0.w, top: 2.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Pasien         : ' + widget.selectedPeriksa.namaPasien!,
          ),
          Text(
            'Tanggal Periksa    : ' + widget.selectedPeriksa.tanggalPeriksa!,
          ),
        ],
      ),
    );
  }

  // BUILD DETAIL DOKTER
  Widget buildDetailDokter() {
    return Padding(
      padding: EdgeInsets.only(left: 7.0.w, top: 4.0.h),
      child: Row(
        children: [
          buildGambarDokter(),
          buildDetailInfoDokter(),
        ],
      ),
    );
  }

  // BUILD GAMBAR DOKTER
  Widget buildGambarDokter() {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final orientation = MediaQuery.of(context).orientation;
    final deviceSize = MediaQuery.of(context).size;
    final imageWidth =
        deviceSize.width * ((orientation == Orientation.portrait) ? 0.25 : 0.2);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            widget.selectedPeriksa.gambarDokter!,
            width: imageWidth,
            height: imageWidth,
            cacheWidth: (300 * devicePixelRatio).round(),
            filterQuality: FilterQuality.none,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  // BUILD DETAIL INFO DOKTER
  Widget buildDetailInfoDokter() {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dokter A'),
          Text(widget.selectedPeriksa.dokterSpesialis!),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Text(widget.selectedPeriksa.jenisPerawatan!),
          )
        ],
      ),
    );
  }

  // BUILD RATING WIDGET
  Widget buildRating() {
    return Padding(
      padding: EdgeInsets.only(left: 7.0.w, top: 2.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beri rating dari dokter ini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          RatingBar.builder(
            initialRating: widget.selectedPeriksa.rating!.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                inputRating = rating;
              });
            },
          )
        ],
      ),
    );
  }

  // BUILD KOMENTAR WIDGET
  Widget buildKomentar() {
    return Padding(
      padding: EdgeInsets.only(left: 7.0.w, top: 3.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berikan Komentar terhadap dokter ini',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 7.0.w, top: 1.0.h),
            child: TextField(
              controller: komentarController,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Berikan komentar anda disini....',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BUILD SIMPAN BATAL BUTTON
  Widget buildSimpanBatalButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // SIMPAN RATING DAN ULASAN
            try {
              if (komentarController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      'Komentar tidak boleh kosong!',
                    ),
                  ),
                );
                return;
              }

              Periksa updatedPeriksa = Periksa(
                  id: widget.selectedPeriksa.id,
                  dokterSpesialis: widget.selectedPeriksa.dokterSpesialis,
                  gambarDokter: widget.selectedPeriksa.gambarDokter,
                  idUser: widget.selectedPeriksa.idUser,
                  jenisPerawatan: widget.selectedPeriksa.jenisPerawatan,
                  namaPasien: widget.selectedPeriksa.namaPasien,
                  price: widget.selectedPeriksa.price,
                  rating: widget.selectedPeriksa.rating,
                  ruangan: widget.selectedPeriksa.ruangan,
                  statusCheckin: widget.selectedPeriksa.statusCheckin,
                  tanggalPeriksa: widget.selectedPeriksa.tanggalPeriksa,
                  ulasan: komentarController.text);

              DaftarPeriksaClient.saveRatingUlasan(updatedPeriksa);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(selectedIndex: 2),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                    'Berhasil mengedit komentar!',
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                    e.toString(),
                  ),
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
          ),
          child: Text(
            'Oke',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          width: 9.0.w,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailPeriksaView(selectedPeriksa: widget.selectedPeriksa),
              ),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            minimumSize: MaterialStateProperty.all(Size(5.w, 4.h)),
          ),
          child: Text(
            'Batal',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Komentar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailPeriksaView(selectedPeriksa: widget.selectedPeriksa),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: !_isLoading
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // buildDetailPeriksa(),
                    buildDetailDokter(),
                    // buildRating(),
                    buildKomentar(),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    buildSimpanBatalButton(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
