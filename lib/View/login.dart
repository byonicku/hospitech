import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/forget_password.dart';
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
        child: Stack(
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: Image.asset(
                'assets/images/pattern.png',
                repeat: ImageRepeat.repeatY,
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.black.withOpacity(0.03),
              ),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Hospitech!",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[400]),
                    ),
                    Image(
                      image: const AssetImage(
                        'assets/images/logo.png',
                      ),
                      width: 50.w,
                    ),
                    //username
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                      child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          // ignore: prefer_const_constructors
                          key: Key('Username'),
                          validator: (username) {
                            if (username!.isEmpty) {
                              return "Tolong isikan username Anda";
                            }
                            return null;
                          },
                          autofocus: false,
                          controller: usernameController,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    //* Password
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                      child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          key: Key('Password'),
                          validator: (value) => value!.isEmpty
                              ? "Tolong isikan password Anda"
                              : null,
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
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              prefixIcon: const Icon(Icons.password),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w),
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
                                  style: TextStyle(fontSize: 14.sp),
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: TextButton(
                                key: Key('RegisterBtn'),
                                onPressed: () {
                                  pushRegister(context);
                                },
                                child: Text(
                                  'Belum punya akun?',
                                  style: TextStyle(fontSize: 14.sp),
                                )),
                          ),
                        ),
                      ],
                    ),
                    //* Baris yang berisi tombol login dan tombol mengarah ke halaman register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //* tombol login
                        ElevatedButton(
                          key: Key('LoginBtn'),
                          //* Fungsi yang dijalankan saat tombol ditekan.
                          onPressed: () async {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
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
                                if (e.toString().contains('TimeoutException')) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Koneksi ke server gagal!'),
                                    ),
                                  );
                                } else if (e
                                    .toString()
                                    .contains("User Tidak Ditemukan")) {
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
                            }
                          }, // onPressed end curly bracket

                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0.h, vertical: 2.0.w),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
