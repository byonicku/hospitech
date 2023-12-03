import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/forget_password.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:intl/intl.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({
    super.key,
  });

  @override
  State<UpdateProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? profilePhoto;
  String? gender;

  bool? isChecked = false;
  bool isDark = darkNotifier.value;
  bool isLoading = true;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User dataUser = await UserClient.show(prefs.getString('id')!);

    setState(() {
      usernameController.text = dataUser.username!;
      emailController.text = dataUser.email!;
      passwordController.text = dataUser.password!;
      notelpController.text = dataUser.noTelp!;
      dateController.text = dataUser.tglLahir!;
      gender = dataUser.jenisKelamin!;
      profilePhoto = dataUser.profilePhoto!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [
                  inputForm((username) {
                    if (username == null || username.isEmpty) {
                      return 'Username tidak boleh kosong';
                    } else if (username.length < 5) {
                      return 'Username minimal 5 karakter';
                    } else {
                      return null;
                    }
                  },
                      controller: usernameController,
                      read: true,
                      labelTxt: "Username",
                      iconData: Icons.person),
                  SizedBox(
                    height: 2.h,
                  ),
                  inputForm((email) {
                    if (email!.isEmpty) {
                      return 'Email tidak boleh kosong';
                    } else if (!email.contains('@')) {
                      return 'Email tidak valid';
                    } else {
                      return null;
                    }
                  },
                      controller: emailController,
                      read: false,
                      labelTxt: "Email",
                      iconData: Icons.email),
                  SizedBox(
                    height: 2.h,
                  ),
                  inputForm((noTelp) {
                    if (noTelp == null || noTelp.isEmpty) {
                      return 'No telepon tidak boleh kosong';
                    } else if (noTelp.length < 10) {
                      return 'No telepon minimal 10 karakter';
                    } else {
                      return null;
                    }
                  },
                      controller: notelpController,
                      read: false,
                      labelTxt: "Nomor Telepon",
                      iconData: Icons.phone_android,
                      textInputType: TextInputType.number),
                  SizedBox(
                    height: 2.h,
                  ),
                  //Date Picker
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                      width: 100.w,
                      child: TextFormField(
                        autofocus: false,
                        controller: dateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tanggal lahir tidak boleh kosong';
                          } else {
                            final inputDate = DateFormat('M/d/y').parse(value);
                            final currentDate = DateTime.now();

                            final age = currentDate.year - inputDate.year;

                            if (age < 13) {
                              return 'Harus berusia minimal 13 tahun';
                            } else {
                              return null;
                            }
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            prefixIcon: Icon(Icons.calendar_today),
                            labelText: "Tanggal Lahir"),
                        readOnly: true, //ketika true maka user gabisa edit
                        showCursor: false,
                        onTap: () async {
                          //ketika di tekan maka akan muncul date picker
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yMd').format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate.toString();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordView()));
                          },
                          child: Text(
                            'Reset Password',
                            style: TextStyle(fontSize: 16.sp),
                          )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      // final data = await getUserByID(prefs.getInt('id'));
                      final data =
                          await UserClient.show(prefs.getString('id')!);

                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> formData = {};
                        formData['username'] = usernameController.text;
                        formData['password'] = passwordController.text;
                        formData['email'] = emailController.text;
                        formData['noTelp'] = notelpController.text;
                        formData['tglLahir'] = dateController.text;
                        formData['gender'] = gender;

                        // kalo UPDATE masalah kemungkinan ini
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Konfirmasi',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            content: const Text(
                                'Apakah data update Anda sudah benar?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  User user = User(
                                      id: data.id,
                                      email: emailController.text,
                                      jenisKelamin: gender,
                                      noTelp: notelpController.text,
                                      password: passwordController.text,
                                      tglLahir: dateController.text,
                                      username: usernameController.text,
                                      profilePhoto: profilePhoto);
                                  try {
                                    await UserClient.update(user);

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const HomeView(
                                          selectedIndex: 1,
                                        ),
                                      ),
                                    );

                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content:
                                            Text('Berhasil Melakukan Update'),
                                      ),
                                    );
                                  } catch (e) {
                                    // print(e.toString());
                                    // ignore: use_build_context_synchronously
                                    if (e
                                        .toString()
                                        .contains('TimeoutException')) {
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Koneksi ke server gagal!'),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Email sudah terdaftar!'),
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
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Gagal Melakukan Update'),
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
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.0.h, vertical: 2.0.w),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
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
