import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';

List<String> listGambarProfilDokter = [
  '/asset/images/doctorProfilePicture/profileDoctor1.jpg',
  '/asset/images/doctorProfilePicture/profileDoctor2.jpg',
  '/asset/images/doctorProfilePicture/profileDoctor3.jpg',
  '/asset/images/doctorProfilePicture/profileDoctor4.jpg',
];

List<String> listJenisPerawatan = ['Rawat Jalan', 'Rawat Inap'];

List<String> listDokterSpesialis = [
  'Spesialis Jantung',
  'Spesialis Organ Dalam',
  'Spesialis Paru - paru',
  'Spesialis Ortopedi'
];

class TambahPeriksa extends StatefulWidget {
  const TambahPeriksa(
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
  State<TambahPeriksa> createState() => _TambahPeriksaState();
}

class _TambahPeriksaState extends State<TambahPeriksa> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaPasienController = TextEditingController();
  TextEditingController tanggalPeriksaController = TextEditingController();
  bool isDark = darkNotifier.value;

  String? selectedJenisPerawatan;
  String? selectedDokterSpesialis;

  @override
  Widget build(BuildContext context) {
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
                    "Daftar Periksa",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                              return 'Dokter Spesialis tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                          controller: namaPasienController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            hintText: "Nama Pasien",
                            labelText: "Nama Pasien",
                            hintStyle: const TextStyle(fontSize: 14),
                            labelStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(Icons.person),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Dokter Spesialis',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedDokterSpesialis,
                        onChanged: (value) {
                          setState(() {
                            selectedDokterSpesialis = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
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
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Jenis Perawatan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedJenisPerawatan,
                        onChanged: (value) {
                          setState(() {
                            selectedJenisPerawatan = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                          hintText: "Tanggal Periksa",
                          labelText: "Tanggal Periksa",
                          hintStyle: const TextStyle(fontSize: 14),
                          labelStyle: const TextStyle(fontSize: 14),
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
                  ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> formData = {};
                          formData['nama_pasien'] = namaPasienController.text;
                          formData['dokter_spesialis'] =
                              selectedDokterSpesialis;
                          formData['jenis_perawatan'] = selectedJenisPerawatan;
                          formData['tanggal_periksa'] =
                              tanggalPeriksaController.text;
                          formData['gambar_dokter'] = listGambarProfilDokter
                              .elementAt(Random().nextInt(3));

                          // kalo register masalah kemungkinan ini
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
                                          final Periksa newPeriksa = Periksa(
                                              namaPasien:
                                                  namaPasienController.text,
                                              dokterSpesialis:
                                                  selectedDokterSpesialis,
                                              jenisPerawatan:
                                                  selectedJenisPerawatan,
                                              tanggalPeriksa:
                                                  tanggalPeriksaController.text,
                                              gambarDokter:
                                                  formData['gambar_dokter']);
                                          addDaftarPeriksa(newPeriksa);
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginView()), //HARUSNTYA TRUS KE TAMPILAN LIST DAFTAR PERIKSA
                                          );
                                          getDaftarPeriksa();

                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Berhasil Melakukan Pendaftaran Periksa'),
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
                                                  'Gagal Melakukan Pendaftaran Periksa'),
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
                          'Daftar Periksa',
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
