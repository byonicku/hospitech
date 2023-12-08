import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:tugas_besar_hospital_pbp/View/register.dart';
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
  bool _isObscuredNew = true;
  bool _isObscureConfirm = true;
  bool _isLoading = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool isLogged = false;

  void refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id') ?? '';
    if (id != '') {
      User dataUser = await UserClient.show(id);
      setState(() {
        usernameController.text = dataUser.username!;
        isLogged = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        isLogged = false;
        _isLoading = false;
      });
    }
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
          'Reset Password',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
          child: !_isLoading
              ? Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //username
                        inputForm((username) {
                          if (username!.isEmpty) {
                            return "Masukkan username Anda";
                          }
                          return null;
                        },
                            controller: usernameController,
                            labelTxt: "Username",
                            read: isLogged,
                            iconData: Icons.person),
                        //* Password lama
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                          child: SizedBox(
                            width: 100.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Masukan Password Lama Anda";
                                } else {
                                  return null;
                                }
                              },
                              controller: passwordController,
                              obscureText: _isObscured,
                              autofocus: false,
                              onChanged: (s) {
                                setState(() {
                                  passwordController.text = s;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Password Lama",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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
                        //password baru
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                          child: SizedBox(
                            width: 100.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Masukan Password Baru Anda";
                                } else if (value.length < 5) {
                                  return "Password Baru minimal 5 karakter";
                                } else {
                                  return null;
                                }
                              },
                              controller: newPasswordController,
                              obscureText: _isObscuredNew,
                              autofocus: false,
                              onChanged: (s) {
                                setState(() {
                                  newPasswordController.text = s;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Password Baru",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                      onTap: () => setState(() {
                                            _isObscuredNew = !_isObscuredNew;
                                          }),
                                      child: Icon(
                                        _isObscuredNew
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ))),
                            ),
                          ),
                        ),
                        //konfrimasi password
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                          child: SizedBox(
                            width: 100.w,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Masukan Konfirmasi Password Anda";
                                } else if (value !=
                                    newPasswordController.text) {
                                  return "Password Konfirmasi Tidak Sama!";
                                } else if (value.length < 5) {
                                  return "Password Baru minimal 5 karakter";
                                } else if (value ==
                                        newPasswordController.text &&
                                    value == passwordController.text) {
                                  return "Password Baru tidak boleh sama dengan Password Lama";
                                } else {
                                  return null;
                                }
                              },
                              controller: confirmNewPasswordController,
                              obscureText: _isObscureConfirm,
                              autofocus: false,
                              onChanged: (s) {
                                setState(() {
                                  confirmNewPasswordController.text = s;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Konfirmasi Password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                      onTap: () => setState(() {
                                            _isObscureConfirm =
                                                !_isObscureConfirm;
                                          }),
                                      child: Icon(
                                        _isObscureConfirm
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
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: prefer_const_constructors
                            SizedBox(
                              height: 9.0.h,
                            ),
                            //* tombol update
                            ElevatedButton(
                              onPressed: () async {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    await UserClient.updatePassword(
                                        usernameController.text,
                                        passwordController.text,
                                        newPasswordController.text);

                                    if (isLogged) {
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
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginView(),
                                        ),
                                      );
                                    }

                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            'Berhasil Melakukan Update Password'),
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        // ignore: prefer_const_constructors
                                        duration: Duration(seconds: 2),
                                        content:
                                            Text(e.toString().split(': ')[1]),
                                      ),
                                    );
                                  }
                                }
                              }, // onPressed end curly bracket

                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0.h, vertical: 2.0.w),
                                child: !_isLoading
                                    ? Text(
                                        'Ubah Password',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
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
