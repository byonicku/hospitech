import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/view/home.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/qr_scanner/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              startDelay: true,
              controller: MobileScannerController(torchEnabled: false),
              fit: BoxFit.contain,
              onDetect: (capture) => setBarcodeCapture(capture),
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 50,
                        child: FittedBox(
                          child: GestureDetector(
                            child: barcodeCaptureTextResult(context),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Text barcodeCaptureTextResult(BuildContext context) {
    return Text(
      "Scan QR Code Ruangan Anda",
      overflow: TextOverflow.fade,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(color: Colors.white),
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    BarcodeCapture? barcodeCapture = capture;
    final String? res = barcodeCapture.barcodes.first.rawValue;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (res != null) {
      print('BERHASIL!!!!!!!!!!');
      if (res.contains(widget.ruang)) {
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

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView(selectedIndex: 2)),
        );

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Berhasil melakukan check in!'),
          ),
        );
      } else {
        print('nope!!!!!!!!!!');
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView(selectedIndex: 2)),
        );

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Anda berada di ruangan yang salah!'),
          ),
        );
      }
    }
  }
}
