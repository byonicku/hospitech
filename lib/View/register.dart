import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:intl/intl.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.noTelp,
    required this.tglLahir,
    required this.jenisKelamin,
  });

  final String? username, email, password, noTelp, tglLahir, jenisKelamin;
  final int? id;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  inputForm((username) {
                    if (username == null || username.isEmpty) {
                      return 'Username tidak boleh kosong';
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
                      return 'No Telp tidak boleh kosong';
                    } else {
                      return null;
                    }
                  },
                      controller: notelpController,
                      hintTxt: "No Telepon",
                      labelTxt: "No Telepon",
                      iconData: Icons.phone_android),
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
                        validator: (value) => value!.isEmpty
                            ? 'Tanggal lahir tidak boleh kosong'
                            : null,
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
                  //check box
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SizedBox(
                        width: 360,
                        child: FormBuilderCheckbox(
                          name: 'accept_terms',
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                          validator: FormBuilderValidators.equal(
                            true,
                            errorText:
                                'You must accept terms and conditions to continue',
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I have read and agree to the ',
                                  style: TextStyle(
                                      color:
                                          isDark ? Colors.white : Colors.black),
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.indigo[300]
                                          : Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar{
                          // const SnackBar(content: Text('Processing Data))};
                          Map<String, dynamic> formData = {};
                          formData['username'] = usernameController.text;
                          formData['password'] = passwordController.text;
                          formData['email'] = emailController.text;
                          formData['noTelp'] = notelpController.text;
                          formData['tglLahir'] = dateController.text;
                          formData['gender'] = gender;

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
                                        onPressed: () {
                                          addUser(User(
                                              id: null,
                                              username: usernameController.text,
                                              email: emailController.text,
                                              jenisKelamin: gender,
                                              noTelp: notelpController.text,
                                              password: passwordController.text,
                                              tglLahir: dateController.text));
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => LoginView()),
                                          );
                                          getUser();
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
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          'Register',
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
