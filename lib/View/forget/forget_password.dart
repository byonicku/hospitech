import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:tugas_besar_hospital_pbp/View/register.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  bool isDark = darkNotifier.value;
  bool _isObscured = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  DateTime backButtonPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //username
                inputLogin((username) {
                  if (username!.isEmpty) {
                    return "Masukkan username Anda";
                  }
                  return null;
                },
                    controller: usernameController,
                    hintTxt: "Username",
                    iconData: Icons.person),
                //* Password
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                  child: SizedBox(
                    width: 100.w,
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Masukkan password Anda" : null,
                      controller: passwordController,
                      obscureText: _isObscured,
                      autofocus: false,
                      onChanged: (s) {
                        setState(() {
                          passwordController.text = s;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                              onTap: () => setState(() {
                                    _isObscured = !_isObscured;
                                  }),
                              child: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ))),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                  ),
                ),
                //* Baris yang berisi tombol login dan tombol mengarah ke halaman register
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //* tombol update
                    ElevatedButton(
                      //* Fungsi yang dijalankan saat tombol ditekan.
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        void navPush(MaterialPageRoute route) {
                          Navigator.pushReplacement(context, route);
                        }

                        //* Cek statenya sudah valid atau belum valid
                        if (_formKey.currentState!.validate()) {
                          //* jika sudah valid, cek username dan password yang diinputkan pada form telah sesuai dengan data yang dibawah
                          //* dari halaman register atau belum

                          try {
                            // User updatePassword = await UserClient.updatePassword(
                            //     usernameController.text,
                            //     passwordController.text);

                            navPush(MaterialPageRoute(
                                builder: (_) => const HomeView(
                                      selectedIndex: 0,
                                    )));
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content:
                                    Text('Berhasil Melakukan Update Password'),
                              ),
                            );
                          } catch (e) {
                            // print(e.toString());

                            if (e
                                .toString()
                                .contains("Username Tidak Ditemukan")) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text(
                                      'Anda belum terdaftar sebagai user!'),
                                ),
                              );
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Username atau password yang Anda masukkan salah'),
                                ),
                              );
                            }
                          }

                          // bool isUsernameRegistered =
                          //     await checkUsername(usernameController.text);
                          // bool isRegistered = await checkLogin(
                          //     usernameController.text, passwordController.text);
                          // if (!isUsernameRegistered) {
                          //   scaffoldMessenger.showSnackBar(
                          //     const SnackBar(
                          //       duration: Duration(seconds: 2),
                          //       content:
                          //           Text('Anda belum terdaftar sebagai user!'),
                          //     ),
                          //   );
                          // } else if (isRegistered) {
                          //   SharedPreferences prefs =
                          //       await SharedPreferences.getInstance();

                          //   final data = await getID(usernameController.text,
                          //       passwordController.text);
                          //   prefs.setInt('id', data.first['id']);

                          //   navPush(MaterialPageRoute(
                          //       builder: (_) => const HomeView(
                          //             selectedIndex: 0,
                          //           )));
                          //   scaffoldMessenger.showSnackBar(
                          //     const SnackBar(
                          //       duration: Duration(seconds: 2),
                          //       content: Text('Berhasil Melakukan Login'),
                          //     ),
                          //   );
                          // } else {

                          // }
                        }
                      }, // onPressed end curly bracket

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0.h, vertical: 2.0.w),
                        child: Text(
                          'Login',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    FocusManager.instance.primaryFocus!.unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}
