import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:tugas_besar_hospital_pbp/View/register.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';

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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    darkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Hospital PBP!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Image(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                  width: 200,
                  height: 200,
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
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: TextButton(
                        onPressed: () {
                          Map<String, dynamic> formData = {};
                          formData['username'] = usernameController.text;
                          formData['password'] = passwordController.text;
                          pushRegister(context);
                        },
                        child: const Text('Belum punya akun ?')),
                  ),
                ),
                //* Baris yang berisi tombol login dan tombol mengarah ke halaman register
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //* tombol login
                    ElevatedButton(
                      //* Fungsi yang dijalankan saat tombol ditekan.
                      onPressed: () {
                        //* Cek statenya sudah valid atau belum valid
                        if (_formKey.currentState!.validate()) {
                          //* jika sudah valid, cek username dan password yang diinputkan pada form telah sesuai dengan data yang dibawah
                          //* dari halaman register atau belum
                          // if (dataForm == null) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       duration: Duration(seconds: 2),
                          //       content:
                          //           Text('Anda belum terdaftar sebagai user!'),
                          //     ),
                          //   );
                          // } else if (dataForm['username'] ==
                          //         usernameController.text &&
                          //     dataForm['password'] == passwordController.text) {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (_) => const HomeView()));
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //       content: Text(
                          //           'Username atau password yang Anda masukkan salah'),
                          //     ),
                          //   );
                          // }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(
            id: null,
            email: null,
            jenisKelamin: null,
            noTelp: null,
            password: null,
            tglLahir: null,
            username: null),
      ),
    );
  }
}
