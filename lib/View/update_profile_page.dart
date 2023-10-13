import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({
    super.key,
  });

  @override
  State<UpdateProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UpdateProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
              onPressed: () async {
                Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final data = await getUserByID(prefs.getInt('id'));
                print(data);
                User user = User(
                    id: data.first['id'],
                    email: emailController.text,
                    jenisKelamin: jenisKelaminController.text,
                    noTelp: noTelpController.text,
                    password: passwordController.text,
                    tglLahir: tglLahirController.text,
                    username: nameController.text);

                updateUserByID(data.first['id'], user);
              },
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
