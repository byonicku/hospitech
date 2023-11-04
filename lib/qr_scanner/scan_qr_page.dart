import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/view/home.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/qr_scanner/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';

class BarcodeScannerPageView extends StatefulWidget {
  final int id;
  final String namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter,
      ruang;

  const BarcodeScannerPageView(
      {Key? key,
      required this.id,
      required this.namaPasien,
      required this.dokterSpesialis,
      required this.jenisPerawatan,
      required this.tanggalPeriksa,
      required this.gambarDokter,
      required this.ruang})
      : super(key: key);

  @override
  State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView>
    with SingleTickerProviderStateMixin {
  Position? pos;
  Position hospitalPos = Position(
      longitude: 110.4153906,
      latitude: -7.7793547,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);
  bool hasScanned = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getPos();
    super.initState();
  }

  void getPos() async {
    Position temp = pos = await _determinePosition();

    setState(() {
      pos = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 138, 138),
      body: PageView(children: [
        cameraView(),
        Container(),
      ]),
    );
  }

  Widget cameraView() {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              controller: MobileScannerController(
                torchEnabled: false,
                facing: CameraFacing.back,
              ),
              fit: BoxFit.fitHeight,
              onDetect: (capture) => {
                getPos(),
                setBarcodeCapture(capture),
              },
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Expanded(
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              height: 100,
                              child: FittedBox(
                                child: Text(
                                  "Scan QR Code Ruangan Anda",
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    BarcodeCapture? barcodeCapture = capture;
    final String? res = barcodeCapture.barcodes.first.rawValue;
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    void returnHome() {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView(selectedIndex: 2)),
      );
    }

    void showSnackBar(Text text) {
      final SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: text,
      );

      scaffoldMessenger.showSnackBar(snackBar);
    }

    if (res != null && !hasScanned) {
      hasScanned = true;

      if (!res.contains(widget.ruang)) {
        // Kalau tidak sama dengan ruangan yang di assign

        returnHome();

        showSnackBar(
          const Text('Anda tidak berada di ruangan yang benar!'),
        );

        return;
      }

      double distance = Geolocator.distanceBetween(hospitalPos.latitude,
          hospitalPos.longitude, pos!.latitude, pos!.longitude);

      // ignore: avoid_print
      print("distance: $distance"); //debug

      if (distance > 30) {
        // ketika jauh dari rumah sakit
        returnHome();

        showSnackBar(
          const Text('Anda tidak berada di area rumah sakit!'),
        );

        return;
      }

      final Periksa updatedPeriksa = Periksa(
        id: widget.id,
        namaPasien: widget.namaPasien,
        dokterSpesialis: widget.dokterSpesialis,
        jenisPerawatan: widget.jenisPerawatan,
        tanggalPeriksa: widget.tanggalPeriksa,
        gambarDokter: widget.gambarDokter,
        ruangan: widget.ruang,
        statusCheckin: 1,
      );

      editPeriksa(updatedPeriksa);

      returnHome();

      showSnackBar(
        const Text('Anda berhasil check-in!'),
      );
    }
  }
}
