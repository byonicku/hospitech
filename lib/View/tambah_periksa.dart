import 'dart:math';
import 'package:tugas_besar_hospital_pbp/database/daftar_periksa_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPeriksa extends StatefulWidget {
  const TambahPeriksa({
    super.key,
    required this.id,
    required this.namaPasien,
    required this.price,
    required this.dokterSpesialis,
    required this.jenisPerawatan,
    required this.tanggalPeriksa,
    required this.gambarDokter,
    required this.ruangan,
  });

  final String? namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter,
      ruangan;

  final int? id, price;

  @override
  State<TambahPeriksa> createState() => _TambahPeriksaState();
}

class _TambahPeriksaState extends State<TambahPeriksa> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaPasienController = TextEditingController();
  TextEditingController tanggalPeriksaController = TextEditingController();
  bool isDark = darkNotifier.value;
  String? id;

  String? selectedJenisPerawatan;
  String? selectedDokterSpesialis;
  double? selectedHargaPerawatan;
  bool isPickedPerawatan = false;
  bool isPickedDokter = false;

  void getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

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
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    "Daftar Periksa",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                    child: SizedBox(
                        width: 100.w,
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
                  SizedBox(
                    height: 2.h,
                  ),
                  //Date Picker
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                    child: SizedBox(
                      width: 100.w,
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
                  SizedBox(
                    height: 2.h,
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 12.0.h, right: 6.0.h),
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
                        value: selectedDokterSpesialis,
                        onChanged: (value) {
                          setState(() {
                            isPickedDokter = true;
                            selectedDokterSpesialis = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
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
                          iconSize: 16.sp,
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
                        menuItemStyleData: MenuItemStyleData(
                          height: 7.h,
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 12.0.h, right: 6.0.h),
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
                        value: selectedJenisPerawatan,
                        onChanged: (value) {
                          setState(() {
                            isPickedPerawatan = true;
                            selectedJenisPerawatan = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
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
                          iconSize: 16.sp,
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
                        menuItemStyleData: MenuItemStyleData(
                          height: 7.h,
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        if (_formKey.currentState!.validate()) {
                          if (!isPickedDokter) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Pilih Dokter Spesialis'),
                              ),
                            );
                          } else if (!isPickedPerawatan) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Pilih Jenis Perawatan'),
                              ),
                            );
                          }

                          if (!isPickedPerawatan || !isPickedDokter) {
                            return;
                          }

                          Map<String, dynamic> formData = {};
                          formData['nama_pasien'] = namaPasienController.text;
                          formData['dokter_spesialis'] =
                              selectedDokterSpesialis;
                          formData['harga_perawatan'] =
                              listHargaPerawatan[selectedDokterSpesialis];
                          formData['jenis_perawatan'] = selectedJenisPerawatan;
                          formData['tanggal_periksa'] =
                              tanggalPeriksaController.text;
                          formData['gambar_dokter'] = listGambarProfilDokter
                              .elementAt(Random().nextInt(3));
                          formData['ruangan'] =
                              listRuangan.elementAt(Random().nextInt(2));

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
                                        onPressed: () async {
                                          final Periksa newPeriksa = Periksa(
                                              namaPasien:
                                                  namaPasienController.text,
                                              dokterSpesialis:
                                                  selectedDokterSpesialis,
                                              price: listHargaPerawatan[
                                                  selectedDokterSpesialis],
                                              jenisPerawatan:
                                                  selectedJenisPerawatan,
                                              tanggalPeriksa:
                                                  tanggalPeriksaController.text,
                                              gambarDokter:
                                                  formData['gambar_dokter'],
                                              ruangan: formData['ruangan'],
                                              statusCheckin: 0);

                                          // addDaftarPeriksa(newPeriksa);
                                          await DaftarPeriksaClient.addPeriksa(
                                              newPeriksa, id!);

                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const HomeView(
                                                    selectedIndex: 2)),
                                          );

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
