import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';

List<String> listGambarProfilDokter = [
  'assets/images/doctorProfilePictures/profileDoctor1.jpg',
  'assets/images/doctorProfilePictures/profileDoctor2.jpg',
  'assets/images/doctorProfilePictures/profileDoctor3.jpg',
  'assets/images/doctorProfilePictures/profileDoctor4.jpg',
];

List<String> listJenisPerawatan = ['Rawat Jalan', 'Rawat Inap'];

List<String> listDokterSpesialis = [
  'Spesialis Jantung',
  'Spesialis Organ Dalam',
  'Spesialis Paru - paru',
  'Spesialis Ortopedi'
];

class EditPeriksaView extends StatefulWidget {
  const EditPeriksaView(
      {super.key,
      required this.id,
      required this.namaPasien,
      required this.dokterSpesialis,
      required this.jenisPerawatan,
      required this.tanggalPeriksa,
      required this.gambarDokter});

  final String? namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter;
  final int? id;

  @override
  State<EditPeriksaView> createState() => _EditPeriksaViewState();
}

class _EditPeriksaViewState extends State<EditPeriksaView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaPasienController = TextEditingController();
  TextEditingController tanggalPeriksaController = TextEditingController();
  bool isDark = darkNotifier.value;
  bool isEditing = false;
  bool changeDokterSpesialis = false;
  bool changeJenisPerawatan = false;
  bool changeNamaPasien = false;
  String? dokterSpesialisSelected, jenisPerawatanSelected, namaPasienSebelumnya;
  // NOTES
  // Disini masih belum sempurna sih, dia waktu edit tu biar data sebelumnya tu kebawa ke controller sini tapi
  // pas di edit tu dia ngga ke reset klo pindah Text field nya gtu itu blm ketemu aku alurnya biar ga ilang editannya
  // klo ini udh berhasil udh selesai sih bagian CRUD ini 👍
  @override
  Widget build(BuildContext context) {
    if (widget.id != null && isEditing == false) {
      isEditing = true;
      namaPasienController.text = widget.namaPasien!;
      tanggalPeriksaController.text = widget.tanggalPeriksa!;
      dokterSpesialisSelected = widget.dokterSpesialis!;
      jenisPerawatanSelected = widget.jenisPerawatan!;
      namaPasienSebelumnya = widget.namaPasien;
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    "Edit Daftar Periksa",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                        width: 360,
                        child: TextFormField(
                          validator: (namaPasien) {
                            if (namaPasien!.isEmpty) {
                              return 'Nama Pasien tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                          controller: namaPasienController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Nama Pasien",
                            labelText: "Nama Pasien",
                            hintStyle: TextStyle(fontSize: 14),
                            labelStyle: TextStyle(fontSize: 14),
                            icon: Icon(Icons.person),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //Date Picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: 360,
                      child: TextFormField(
                        autofocus: false,
                        controller: tanggalPeriksaController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tanggal Periksa tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.calendar_today),
                          hintText: "Tanggal Periksa",
                          labelText: "Tanggal Periksa",
                          hintStyle: TextStyle(fontSize: 14),
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        readOnly: true, //ketika true maka user gabisa edit
                        showCursor: false,
                        onTap: () async {
                          //ketika di tekan maka akan muncul date picker
                          DateTime initialDate =
                              DateTime.now().add(const Duration(days: 1));
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: initialDate,
                              lastDate: DateTime(2050));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yMd').format(pickedDate);
                            setState(() {
                              tanggalPeriksaController.text =
                                  formattedDate.toString();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0, left: 72.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Dokter Spesialis',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: listDokterSpesialis
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: dokterSpesialisSelected,
                        onChanged: (value) {
                          setState(() {
                            dokterSpesialisSelected = value!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade700,
                            ),
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: IconStyleData(
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.grey.shade700,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 32.0, left: 72.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Jenis Perawatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: listJenisPerawatan
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: jenisPerawatanSelected,
                        onChanged: (value) {
                          setState(() {
                            jenisPerawatanSelected = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade700,
                            ),
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: IconStyleData(
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.grey.shade700,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          offset: const Offset(0, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> formData = {};
                          formData['nama_pasien'] =
                              namaPasienController.text == namaPasienSebelumnya
                                  ? namaPasienSebelumnya
                                  : namaPasienController.text;
                          formData['dokter_spesialis'] =
                              dokterSpesialisSelected;
                          formData['jenis_perawatan'] = jenisPerawatanSelected;
                          formData['tanggal_periksa'] =
                              tanggalPeriksaController.text ==
                                      widget.tanggalPeriksa!
                                  ? widget.tanggalPeriksa!
                                  : tanggalPeriksaController.text;
                          formData['gambar_dokter'] = listGambarProfilDokter
                              .elementAt(Random().nextInt(3));

                          // kalo ada masalah kemungkinan ini
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: const Text('Konfirmasi',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    content: const Text(
                                        'Apakah data Anda sudah benar?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          final Periksa updatedPeriksa =
                                              Periksa(
                                                  id: widget.id,
                                                  namaPasien:
                                                      namaPasienController.text,
                                                  dokterSpesialis: formData[
                                                      'dokter_spesialis'],
                                                  jenisPerawatan: formData[
                                                      'jenis_perawatan'],
                                                  tanggalPeriksa:
                                                      tanggalPeriksaController
                                                          .text,
                                                  gambarDokter: formData[
                                                      'gambar_dokter']);
                                          editPeriksa(updatedPeriksa);
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const HomeView(
                                                    selectedIndex: 2)),
                                          );
                                          getDaftarPeriksa();

                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Berhasil Melakukan Update Data Periksa'),
                                            ),
                                          );
                                        },
                                        child: Text('Sudah',
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Gagal Melakukan Update data Periksa'),
                                            ),
                                          );
                                        },
                                        child: Text('Belum',
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ));
                        }
                      }, // onPressed end curly bracket

                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          'Edit Periksa',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
