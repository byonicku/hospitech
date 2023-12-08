import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/database/daftar_periksa_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/periksa.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:tugas_besar_hospital_pbp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPeriksaView extends StatefulWidget {
  const EditPeriksaView(
      {super.key,
      required this.id,
      required this.namaPasien,
      required this.price,
      required this.dokterSpesialis,
      required this.jenisPerawatan,
      required this.tanggalPeriksa,
      required this.gambarDokter});

  final String? namaPasien,
      dokterSpesialis,
      jenisPerawatan,
      tanggalPeriksa,
      gambarDokter;
  final int? id, price;

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
  String? id;
  double selectedHargaPerawatan = 0;

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
    if (widget.id != null && isEditing == false) {
      isEditing = true;
      namaPasienController.text = widget.namaPasien!;
      tanggalPeriksaController.text = widget.tanggalPeriksa!;
      dokterSpesialisSelected = widget.dokterSpesialis!;
      jenisPerawatanSelected = widget.jenisPerawatan!;
      namaPasienSebelumnya = widget.namaPasien;
      selectedHargaPerawatan = widget.price!.toDouble();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
        title: Text(
          'Edit Daftar Periksa',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 6.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0.h,
                    ),
                    child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          key: Key('Nama Pasien'),
                          validator: (namaPasien) {
                            if (namaPasien!.isEmpty) {
                              return 'Nama Pasien tidak boleh kosong';
                            } else {
                              return null;
                            }
                          },
                          controller: namaPasienController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelText: "Nama Pasien",
                            hintStyle: TextStyle(fontSize: 14),
                            labelStyle: TextStyle(fontSize: 14),
                            prefixIcon: Icon(Icons.person),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  //Date Picker
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0.h,
                    ),
                    child: SizedBox(
                      width: 100.w,
                      child: TextFormField(
                        key: Key('TglPeriksa'),
                        autofocus: false,
                        controller: tanggalPeriksaController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tanggal Periksa tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          prefixIcon: Icon(Icons.calendar_today),
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
                              switchToInputEntryModeIcon: Icon(Icons.edit),
                              context: context,
                              initialDate: initialDate,
                              firstDate: initialDate,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 14)));
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
                    padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                    child: DropdownButtonHideUnderline(
                      key: Key('Dokter Dropdown'),
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
                                  key: Key(item),
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
                            selectedHargaPerawatan =
                                listHargaPerawatan[dokterSpesialisSelected!]!
                                    .toDouble();
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0)),
                            ],
                            borderRadius: BorderRadius.circular(20),
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
                            borderRadius: BorderRadius.circular(20),
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          offset: const Offset(0, -3),
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
                    height: 12,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                    child: DropdownButtonHideUnderline(
                      key: Key('Jenis Perawatan'),
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Pilih Jenis Perawatan',
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                                  key: Key(item),
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 16.sp,
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
                          padding: EdgeInsets.only(left: 2.h, right: 2.h),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0)),
                            ],
                            borderRadius: BorderRadius.circular(20),
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
                            borderRadius: BorderRadius.circular(20),
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                          offset: const Offset(0, -3),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Biaya : ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ')
                            .format(selectedHargaPerawatan),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      key: Key('Edit Periksa'),
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
                          formData['price'] =
                              listHargaPerawatan[dokterSpesialisSelected!];
                          formData['jenis_perawatan'] = jenisPerawatanSelected;
                          formData['tanggal_periksa'] =
                              tanggalPeriksaController.text ==
                                      widget.tanggalPeriksa!
                                  ? widget.tanggalPeriksa!
                                  : tanggalPeriksaController.text;
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
                                        key: Key('SudahBtn'),
                                        onPressed: () async {
                                          try {
                                            final Periksa updatedPeriksa =
                                                Periksa(
                                                    id: widget.id,
                                                    namaPasien:
                                                        namaPasienController
                                                            .text,
                                                    dokterSpesialis: formData[
                                                        'dokter_spesialis'],
                                                    jenisPerawatan: formData[
                                                        'jenis_perawatan'],
                                                    tanggalPeriksa:
                                                        tanggalPeriksaController
                                                            .text,
                                                    price: formData['price'],
                                                    ruangan:
                                                        formData['ruangan'],
                                                    statusCheckin: 0,
                                                    gambarDokter: formData[
                                                        'gambar_dokter']);

                                            await DaftarPeriksaClient.update(
                                                updatedPeriksa, id!);

                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const HomeView(
                                                          selectedIndex: 2)),
                                            );

                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    'Berhasil Melakukan Update Data Periksa'),
                                              ),
                                            );
                                          } on Exception catch (e) {
                                            if (e
                                                .toString()
                                                .contains('TimeoutException')) {
                                              scaffoldMessenger.showSnackBar(
                                                const SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content: Text(
                                                      'Koneksi ke server gagal!'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text('Sudah',
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      TextButton(
                                        key: Key('BelumBtn'),
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
