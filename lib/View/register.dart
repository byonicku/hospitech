import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:intl/intl.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
  });

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
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // inputForm((username) {
                  // if (username == null || username.isEmpty) {
                  //   return 'Username tidak boleh kosong';
                  // } else if (username.length < 5) {
                  //   return 'Username minimal 5 karakter';
                  // } else {
                  //   return null;
                  // }
                  // },
                  //     controller: usernameController,
                  //     hintTxt: "Username",
                  //     labelTxt: "Username",
                  //     iconData: Icons.person),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          // ignore: prefer_const_constructors
                          key: Key('Username'),
                          validator: (username) {
                            if (username == null || username.isEmpty) {
                              return 'Username tidak boleh kosong';
                            } else if (username.length < 5) {
                              return 'Username minimal 5 karakter';
                            } else {
                              return null;
                            }
                          },
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Username",
                            labelText: "Username",
                            icon: Icon(Icons.person),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          // ignore: prefer_const_constructors
                          key: Key('Email'),
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
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                      width: 100.w,
                      child: TextFormField(
                        // ignore: prefer_const_constructors
                        key: Key('Password'),
                        validator: (password) {
                          if (password!.isEmpty) {
                            return "Password tidak boleh kosong";
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
                  SizedBox(
                    height: 2.h,
                  ),
                  // inputForm((noTelp) {
                  // if (noTelp == null || noTelp.isEmpty) {
                  //   return 'No telepon tidak boleh kosong';
                  // } else if (noTelp.length < 10) {
                  //   return 'No telepon minimal 10 karakter';
                  // } else {
                  //   return null;
                  // }
                  // },
                  //     controller: notelpController,
                  //     hintTxt: "No Telepon",
                  //     labelTxt: "No Telepon",
                  //     iconData: Icons.phone_android,
                  //     textInputType: TextInputType.number),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                        width: 100.w,
                        child: TextFormField(
                          // ignore: prefer_const_constructors
                          key: Key('No Telepon'),
                          validator: (noTelp) {
                            if (noTelp == null || noTelp.isEmpty) {
                              return 'No telepon tidak boleh kosong';
                            } else if (noTelp.length < 10) {
                              return 'No telepon minimal 10 karakter';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller: notelpController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "No Telepon",
                            labelText: "No Telepon",
                            icon: Icon(Icons.phone_android),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  //Date Picker
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                    child: SizedBox(
                      width: 100.w,
                      child: TextFormField(
                        // ignore: prefer_const_constructors
                        key: Key('TglLahir'),
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
                              // ignore: prefer_const_constructors
                              switchToInputEntryModeIcon: Icon(Icons.edit),
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
                  SizedBox(
                    height: 2.h,
                  ),
                  //radio button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.0.h,
                    ),
                    child: SizedBox(
                      width: 100.w,
                      child: FormBuilderRadioGroup(
                        // ignore: prefer_const_constructors
                        key: Key('Gender'),
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
                      padding: EdgeInsets.symmetric(horizontal: 4.0.h),
                      child: SizedBox(
                        width: 100.w,
                        height: 10.h,
                        child: FormBuilderCheckbox(
                          // ignore: prefer_const_constructors
                          key: Key('AcceptTerms'),
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
                                          isDark ? Colors.white : Colors.black,
                                      fontSize: 14.sp),
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.indigo[300]
                                          : Colors.blue,
                                      fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  ElevatedButton(
                      // ignore: prefer_const_constructors
                      key: Key('RegisterBtn'),
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> formData = {};
                          formData['username'] = usernameController.text;
                          formData['password'] = passwordController.text;
                          formData['email'] = emailController.text;
                          formData['noTelp'] = notelpController.text;
                          formData['tglLahir'] = dateController.text;
                          formData['gender'] = gender;

                          // bool isEmailRegistered =
                          //     await checkEmail(emailController.text);

                          // if (isEmailRegistered) {
                          //   scaffoldMessenger.showSnackBar(
                          //     const SnackBar(
                          //       duration: Duration(seconds: 2),
                          //       content: Text('Email sudah terdaftar!'),
                          //     ),
                          //   );
                          //   return;
                          // }

                          // kalo register masalah kemungkinan ini
                          // ignore: use_build_context_synchronously
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
                                        // ignore: prefer_const_constructors
                                        key: Key('SudahBtn'),
                                        onPressed: () async {
                                          // addUser(User(
                                          //     id: null,
                                          //     username: usernameController.text,
                                          //     email: emailController.text,
                                          //     jenisKelamin: gender,
                                          //     noTelp: notelpController.text,
                                          //     password: passwordController.text,
                                          //     tglLahir: dateController.text));
                                          try {
                                            await UserClient.register(User(
                                                id: null,
                                                username:
                                                    usernameController.text,
                                                email: emailController.text,
                                                jenisKelamin: gender,
                                                noTelp: notelpController.text,
                                                password:
                                                    passwordController.text,
                                                tglLahir: dateController.text));

                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginView()),
                                            );

                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    'Berhasil Melakukan Registrasi'),
                                              ),
                                            );
                                          } catch (e) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    'Email sudah terdaftar!'),
                                              ),
                                            );
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
                                        // ignore: prefer_const_constructors
                                        key: Key('BelumBtn'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Gagal Melakukan Registrasi'),
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
                                  ));
                        }
                      }, // onPressed end curly bracket

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0.h, vertical: 2.0.w),
                        child: Text(
                          'Register',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      )),
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
