import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:tugas_besar_hospital_pbp/invoice/preview_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/invoice/get_price.dart';

Future<void> createPdf(
  int idPeriksa,
  String id,
  BuildContext context,
) async {
  void navigateToPreviewScreen(pw.Document doc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreviewScreen(doc: doc)),
    );
  }

  Periksa userPeriksa = await getPeriksaByID(idPeriksa);

  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd  HH:mm:ss').format(now);

  final imageLogo =
      (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
  final imageInvoice = pw.MemoryImage(imageLogo);

  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#60efff'),
            width: 1.w,
          ),
        ),
      );
    },
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pdfTheme,
      header: (pw.Context context) {
        return headerPdf();
      },
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                    margin: pw.EdgeInsets.symmetric(
                        horizontal: 2.h, vertical: 2.h)),
                topOfInvoice(imageInvoice),
                personalDataFromInput(
                    userPeriksa.namaPasien!,
                    userPeriksa.dokterSpesialis!,
                    userPeriksa.jenisPerawatan!,
                    userPeriksa.tanggalPeriksa!,
                    userPeriksa.ruangan!),
                contentOfInvoice(userPeriksa),
                underOfInvoice(),
                pw.SizedBox(height: 5.h),
                barcodeGaris(id),
              ],
            ),
          ),
        ];
      },
      footer: (pw.Context context) {
        return pw.Container(
          color: PdfColor.fromHex('#00ff87'),
          child: footerPDF(formattedDate),
        );
      },
    ),
  );

  navigateToPreviewScreen(doc);
}

pw.Header headerPdf() {
  return pw.Header(
    margin: pw.EdgeInsets.zero,
    outlineColor: PdfColors.amber50,
    outlineStyle: PdfOutlineStyle.normal,
    level: 5,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromHex('#00ff87'),
          PdfColor.fromHex('#60efff'),
        ],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Text(
        '- Hospital PBP -',
        style: pw.TextStyle(
          fontSize: 12.sp,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
  );
}

pw.Padding personalDataFromInput(String nama, String dokterSpesialis,
    String jenisPerawatan, String tanggalPeriksa, String ruangan) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text('Nama Pasien',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14.sp,
                  )),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                nama,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Tanggal Periksa',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(tanggalPeriksa,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14.sp,
                  )),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Dokter Spesialis',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(dokterSpesialis,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14.sp,
                  )),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Jenis Perawatan',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                jenisPerawatan,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                'Ruangan',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
              child: pw.Text(
                ruangan,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Padding topOfInvoice(pw.MemoryImage imageInvoice) {
  pw.TextStyle gridTextStyle = pw.TextStyle(
    fontSize: 10.sp,
    color: PdfColors.blue800,
  );

  return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(imageInvoice, height: 30.h, width: 30.w),
            pw.Expanded(
              child: pw.Container(
                height: 10.h,
                decoration: const pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: PdfColors.greenAccent,
                ),
                padding: const pw.EdgeInsets.only(
                    left: 40, top: 10, bottom: 10, right: 40),
                alignment: pw.Alignment.centerLeft,
                child: pw.DefaultTextStyle(
                  style: const pw.TextStyle(
                      color: PdfColors.amber100, fontSize: 12),
                  child: pw.GridView(
                    crossAxisCount: 2,
                    children: [
                      pw.Text('Hospital PBP', style: gridTextStyle),
                      pw.Text('Babarsari Street 10', style: gridTextStyle),
                      pw.SizedBox(height: 1.h),
                      pw.Text('Yogyakarta 1234', style: gridTextStyle),
                      pw.SizedBox(height: 1.h),
                      pw.SizedBox(height: 1.h),
                      pw.Text('Contact Us', style: gridTextStyle),
                      pw.SizedBox(height: 1.h),
                      pw.Text('Phone Number', style: gridTextStyle),
                      pw.Text('0812345678', style: gridTextStyle),
                      pw.Text('Email', style: gridTextStyle),
                      pw.Text('tugasbesarpbphospital@gmail.com',
                          style: gridTextStyle),
                    ],
                  ),
                ),
              ),
            ),
          ]));
}

pw.Padding contentOfInvoice(Periksa periksa) {
  final moneyFormat = NumberFormat("#,##0", "en_US");

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
    child: pw.Align(
      alignment: pw.Alignment.topLeft,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Biaya Periksa : Rp ${moneyFormat.format(periksa.price)}',
            style: pw.TextStyle(fontSize: 16.sp),
          ),
          pw.SizedBox(height: 1.h),
          pw.Text(
            'PPN (10%) : Rp ${moneyFormat.format(getPPNTotal(periksa))}',
            style: pw.TextStyle(fontSize: 16.sp),
          ),
          pw.SizedBox(height: 1.h),
          pw.Text(
            'Total : Rp ${moneyFormat.format(getTotal(periksa))}',
            style: pw.TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    ),
  );
}

pw.Padding underOfInvoice() {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
    child: pw.Column(children: [
      pw.SizedBox(height: 3.h),
      pw.Text(
          "Semoga cepat sembuh, dan jangan lupa untuk selalu menjaga kesehatan Anda."),
      pw.SizedBox(height: 3.h),
      pw.Text("Thanks for your trust, and till the next time."),
      pw.SizedBox(height: 3.h),
      pw.Text("Kind regards,"),
      pw.SizedBox(height: 3.h),
      pw.Text("Kelompok 2 PBP"),
    ]),
  );
}

pw.Container barcodeGaris(String id) {
  return pw.Container(
    child: pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
      child: pw.BarcodeWidget(
        barcode: Barcode.code128(escapes: true),
        data: id,
        width: 20.w,
        height: 10.h,
      ),
    ),
  );
}

pw.Center footerPDF(String formattedDate) {
  return pw.Center(
      child: pw.Text("Created at $formattedDate",
          style: pw.TextStyle(
            fontSize: 10.sp,
            color: PdfColors.blue,
          )));
}
