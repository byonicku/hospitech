import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tugas_besar_hospital_pbp/component/alert.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tugas_besar_hospital_pbp/main.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //* untuk validasi harus menggunakan GlokayKey
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
                  inputForm(
                      (p0) => p0 == null || p0.isEmpty
                          ? 'Username tidak boleh kosong'
                          : null,
                      controller: usernameController,
                      hintTxt: "Username",
                      labelTxt: "Username",
                      iconData: Icons.person),
                  const SizedBox(
                    height: 12,
                  ),
                  inputForm(
                      (p0) => p0 == null || p0.isEmpty
                          ? 'Email tidak boleh kosong'
                          : !p0.contains('@')
                              ? 'Email tidak valid'
                              : null,
                      controller: emailController,
                      hintTxt: "Email",
                      labelTxt: "Email",
                      iconData: Icons.email),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextFormField(
                      validator: (value) => value!.isEmpty
                          ? "Tolong isikan password Anda"
                          : value.length < 5
                              ? "Password minimal 5 karakter"
                              : null,
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
                  const SizedBox(
                    height: 12,
                  ),
                  inputForm(
                      (p0) => p0 == null || p0.isEmpty
                          ? 'No Telp tidak boleh kosong'
                          : null,
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
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
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
                    ),
                  ),
                  //check box
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                          showDialog(
                              context: context,
                              builder: (_) => alert(context, formData));
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
