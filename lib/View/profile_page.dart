import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Hendry';
  String email = 'Hendry@gmail.com';
  String password = 'Hendry123';
  String noTelp = '08123456789';
  String tglLahir = '07/01/2007';
  String jenisKelamin = 'Laki-Laki';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    emailController.text = email;
    passwordController.text = password;
    noTelpController.text = noTelp;
    tglLahirController.text = tglLahir;
    jenisKelaminController.text = jenisKelamin;
  }

  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('password', passwordController.text);
    prefs.setString('noTelp', noTelpController.text);
    prefs.setString('tglLahir', tglLahirController.text);
    prefs.setString('jenisKelamin', jenisKelaminController.text);
    setState(() {
      name = nameController.text;
      email = emailController.text;
      password = passwordController.text;
      noTelp = noTelpController.text;
      tglLahir = tglLahirController.text;
      jenisKelamin = jenisKelaminController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              controller: noTelpController,
              decoration: const InputDecoration(
                labelText: 'noTelp',
              ),
            ),
            TextField(
              controller: tglLahirController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Lahir',
              ),
            ),
            TextField(
              controller: jenisKelaminController,
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update'),
            ),
            const SizedBox(height: 16.0),
            Text('Nama : $name'),
            Text('Email : $email'),
            Text('Password: $password'),
            Text('noTelp : $noTelp'),
            Text('tglLahir : $tglLahir'),
            Text('Jenis Kelamin : $jenisKelamin'),
          ],
        ),
      ),
    );
  }
}
