import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  String? gender;

  bool? isChecked = false;
  bool _isObscured = true;
  bool isDark = darkNotifier.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                      hintTxt: "Username",
                      labelTxt: "Username",
                      iconData: Icons.person),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                        width: 360,
                        child: TextFormField(
                          validator: (email) {
                            if (email!.isEmpty) {
                              return 'Email tidak boleh kosong';
                            } else if (!email.contains('@')) {
                              return 'Email tidak valid';
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Email",
                            labelText: "Email",
                            icon: Icon(Icons.email),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: 360,
                      child: TextFormField(
                        validator: (password) {
                          if (password!.isEmpty) {
                            return "Tolong isikan password Anda";
                          } else if (password.length < 5) {
                            return "Password minimal 5 karakter";
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        obscureText: _isObscured,
                        onChanged: (s) {
                          setState(() {
                            passwordController.text = s;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
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
                  const SizedBox(
                    height: 12,
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
                      hintTxt: "No Telepon",
                      labelTxt: "No Telepon",
                      iconData: Icons.phone_android,
                      textInputType: TextInputType.number),
                  const SizedBox(
                    height: 12,
                  ),
                  //Date Picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: 360,
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
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.calendar_today),
                            hintText: "Tanggal Lahir",
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
                  const SizedBox(
                    height: 12,
                  ),
                  //radio button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                    child: SizedBox(
                      width: 360,
                      child: FormBuilderRadioGroup(
                        decoration: const InputDecoration(labelText: 'Gender'),
                        name: "gender",
                        validator: FormBuilderValidators.required(
                            errorText: "Jenis kelamin tidak boleh kosong"),
                        options: [
                          "Laki-Laki",
                          "Perempuan",
                        ]
                            .map((e) => FormBuilderFieldOption(value: e))
                            .toList(growable: false),
                        onChanged: (value) => setState(() {
                          gender = value;
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final data = await getUserByID(prefs.getInt('id'));

                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> formData = {};
                        formData['username'] = usernameController.text;
                        formData['password'] = passwordController.text;
                        formData['email'] = emailController.text;
                        formData['noTelp'] = notelpController.text;
                        formData['tglLahir'] = dateController.text;
                        formData['gender'] = gender;

                        bool isEmailRegistered =
                            await checkEmail(emailController.text);

                        if (isEmailRegistered) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Email sudah terdaftar!'),
                            ),
                          );
                          return;
                        }

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
                                onPressed: () {
                                  User user = User(
                                      id: data.first['id'],
                                      email: emailController.text,
                                      jenisKelamin: gender,
                                      noTelp: notelpController.text,
                                      password: passwordController.text,
                                      tglLahir: dateController.text,
                                      username: usernameController.text);
                                  updateUserByID(data.first['id'], user);

                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
