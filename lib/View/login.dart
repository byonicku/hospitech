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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                  "Welcome to Hospital PBP!",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image(
                  image: const AssetImage(
                    'assets/images/logo.png',
                  ),
                  width: 40.w,
                  height: 40.h,
                ),
                //username
                inputLogin((username) {
                  if (username!.isEmpty) {
                    return "Tolong isikan username Anda";
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
                          value!.isEmpty ? "Tolong isikan password Anda" : null,
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
                    child: TextButton(
                        onPressed: () {
                          pushRegister(context);
                        },
                        child: Text(
                          'Belum punya akun ?',
                          style: TextStyle(fontSize: 13.sp),
                        )),
                  ),
                ),
                //* Baris yang berisi tombol login dan tombol mengarah ke halaman register
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //* tombol login
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
                            User loggedIn = await UserClient.login(
                                usernameController.text,
                                passwordController.text);

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('id', loggedIn.id!.toString());

                            navPush(MaterialPageRoute(
                                builder: (_) => const HomeView(
                                      selectedIndex: 0,
                                    )));
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Berhasil Melakukan Login'),
                              ),
                            );
                          } catch (e) {
                            // print(e.toString());

                            if (e.toString().contains("User Tidak Ditemukan")) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isDark = !isDark;
          darkNotifier.value = isDark;
        },
        tooltip: "Ganti Tema",
        child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
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
