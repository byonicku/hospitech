import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
//* Sesuai dengan nama project Anda ,  awalnya akan error pada home,register,form component karena belum dibuat

class LoginView extends StatefulWidget {
  //* Variable map data dibuat bersifat nullable, karena ketika aplikasi dijalankan(dipanggil dari main, tidak ada data yang dibawa)
  //* data memiliki nilai ketika registrasi berhasil dilakukan
  final Map? data;
  //* Agar Map data bisa bersifat nullable, pada constructor dibungkus dengan kurung { } agar bersifat opsional
  LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

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
    bool isDark = darkNotifier.value;
    //* TextEditingController
    //* widget mengacu pada instance / objek LoginView
    Map? dataForm = widget.data;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 32,
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
                        // pushRegister(context);
                      },
                      child: const Text('Belum punya akun ?')),
                ),
              ),
              //* Baris yang berisi tombol login dan tombol mengarah ke halaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //* tombol login
                  MaterialButton(
                    //* Fungsi yang dijalankan saat tombol ditekan.
                    onPressed: () {
                      //* Cek statenya sudah valid atau belum valid
                      if (_formKey.currentState!.validate()) {
                        //* jika sudah valid, cek username dan password yang diinputkan pada form telah sesuai dengan data yang dibawah
                        //* dari halaman register atau belum
                        if (dataForm!['username'] == usernameController.text &&
                            dataForm['password'] == passwordController.text) {
                          //* Jika sesuai navigasi ke halaman Home
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: () {});
                          // => const HomeView()));
                        } else {
                          //* Jika belum tampilkan Alert dialog
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Password Salah'),
                              //* isi Alert Dialog
                              content: TextButton(
                                  //* pushRegister(context) fungsi pada baris 118-124 untuk meminimalkan nested code
                                  onPressed: () {},
                                  // => pushRegister(context),
                                  child: const Text('Daftar Disini !!')),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    color: isDark
                        ? ThemeData().primaryColorDark
                        : ThemeData().primaryColor,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  //* tombol ke halaman register
                ],
              ),
            ],
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

  // void pushRegister(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => const RegisterView(),
  //     ),
  //   );
  // }
}
