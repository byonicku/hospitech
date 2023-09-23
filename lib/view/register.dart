import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/component/form_component.dart';
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
                  inputForm(
                      (p0) => p0 == null || p0.isEmpty
                          ? 'Password tidak boleh kosong'
                          : p0.length < 5
                              ? 'Password minimal 5 karakter'
                              : null,
                      controller: passwordController,
                      hintTxt: "Password",
                      labelTxt: "Password",
                      iconData: Icons.password,
                      password: true),
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
                        autofocus: true,
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
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: 360,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Gender'),
                          Radio(
                            value: 'pria',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          const Text('Pria'),
                          Radio(
                            value: 'wanita',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          const Text('Wanita'),
                        ],
                      ),
                    ),
                  ),

                  //check box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("I agree to the terms and conditions"),
                      value: isChecked,
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      },
                    ),
                  ),

                  MaterialButton(
                      color: ThemeData().primaryColor,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar{
                          // const SnackBar(content: Text('Processing Data))};
                          Map<String, dynamic> formData = {};
                          formData['username'] = usernameController.text;
                          formData['password'] = passwordController.text;
                          //* Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext) => LoginView(data: formData ,)) );
                          //  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginView(data: formData ,)) );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Text('Register'),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
