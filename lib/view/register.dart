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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Usernme Tidak Boleh Kosong';
                }
                if (p0.toLowerCase() == 'anjing') {
                  return 'Tidak boleh menggunakan kata kasar';
                }
                return null;
              },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Ucup Surucup",
                  iconData: Icons.person),

              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!p0.contains('@')) {
                  return 'Email harus menggunakan @';
                }
                return null;
              }),
                  controller: emailController,
                  hintTxt: "Email",
                  helperTxt: "ucup@gmail.com",
                  iconData: Icons.email),

              inputForm(
                  //* Pola validasi lebih detail bisa menggunakan regex
                  ((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (p0.length < 5) {
                  return 'Password minimal 5 digit';
                }
                return null;
              }),
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "xxxxxxx",
                  iconData: Icons.password,
                  password: true),

              inputForm(((p0) {
                //* untuk menglihat contoh penggunaan regex,uncomment baris dibawah yang dicomment
                //* final RegExp regex = RegExp(r'^\0?[1-9]\d{1,14}$');
                if (p0 == null || p0.isEmpty) {
                  return 'Nomor Telepon tidak boleh kosong';
                }
                // if(!regex.hasMatch(p0))
                // {
                // return 'Nomor Telepon tidak valid';
                // }
                return null;
              }),
                  controller: notelpController,
                  hintTxt: "No Telp",
                  helperTxt: "082123456789",
                  iconData: Icons.phone_android),

              //Date Picker
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    autofocus: true,
                    controller: dateController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
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
                      } else {
                        print("Tanggal lahir tidak boleh kosong");
                      }
                    },
                  ),
                ),
              ),

              //radio button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,  // kalo start dia mentok kiri :v 
                children: [
                  Text('Gender'),
                  Radio(
                    value: 'pria',
                    groupValue: AutofillHints.gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  Text('Pria'),
                  Radio(
                    value: 'wanita',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  Text('Wanita'),
                ],
              ),

              //check box
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: SizedBox(
                    width: 350,
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("I agree to the terms and conditions"),
                      value: isChecked,
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      },
                    )),
              ),

              ElevatedButton(
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
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
