// import 'package:flutter/material.dart';
// import 'package:ugd1/View/login.dart';
// import 'package:ugd1/component/form_component.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

// @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController notelpController = TextEditingController();
//   bool isAgreed = false; // Tambahkan variabel untuk mengontrol status checkbox

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
//               inputForm((p0) {
//                 if (p0 == null || p0.isEmpty) {
//                   return 'username Tidak Boleh Kosong';
//                 }
//                 return null;
//               },
//                   controller: usernameController,
//                   hintTxt: "Username",
//                   helperTxt: "Ucup Serucup",
//                   iconData: Icons.person),
//               inputForm(((p0) {
//                 if (p0 == null || p0.isEmpty) {
//                   return 'Email Tidak Boleh Kosong';
//                 }
//                 if (!p0.contains('@')) {
//                   return 'Email harus menggunakan @';
//                 }
//                 return null;
//               }),
//                   controller: emailController,
//                   hintTxt: "Email",
//                   helperTxt: "berly@gmail.com",
//                   iconData: Icons.email),
//               inputForm(((p0) {
//                 if (p0 == null || p0.isEmpty) {
//                   return 'Password tidak boleh kosong';
//                 }
//                 if (p0.length < 8) {
//                   return 'Password Harus 8 digit';
//                 }
//                 return null;
//               }),
//                   controller: passwordController,
//                   hintTxt: "Password",
//                   helperTxt: "xxxxxxxx",
//                   iconData: Icons.password,
//                   password: true),
//               inputForm(((p0) {
//                 if (p0 == null || p0.isEmpty) {
//                   return 'Nomor telepon tidak Boleh kosong';
//                 }
//                 return null;
//               }),
//                   controller: notelpController,
//                   hintTxt: "No Telp",
//                   helperTxt: "08216734894",
//                   iconData: Icons.phone_android),
//               CheckboxListTile(
//                 title: Text('Saya setuju dengan Syarat dan Ketentuan'),
//                 value: isAgreed,
//                 onChanged: (newValue) {
//                   setState(() {
//                     isAgreed = newValue!;
//                   });
//                 },
//               ),
              ElevatedButton(
                onPressed: () {
                  if (isAgreed) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Konfirmasi'),
                          content: Text('Apakah data anda sudah benar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginView()),
                                );
                              },
                              child: Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Peringatan'),
                          content: Text(
                              'Anda harus menyetujui Syarat dan Ketentuan.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                // child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }