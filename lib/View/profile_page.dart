import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/update_profile_page.dart';
import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> currentUser = [];
  String? name, email, password, noTelp, tglLahir, jenisKelamin;

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await getUserByID(prefs.getInt('id'));
    setState(() {
      currentUser = data;
      name = currentUser.first['username'];
      email = currentUser.first['email'];
      password = currentUser.first['password'];
      noTelp = currentUser.first['no_telp'];
      tglLahir = currentUser.first['tanggal_lahir'];
      jenisKelamin = currentUser.first['jenis_kelamin'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/profil.png'),
              ),
              const SizedBox(height: 20),
              ProfileInfo(label: 'Nama', value: name),
              ProfileInfo(label: 'Email', value: email),
              ProfileInfo(label: 'No. Telepon', value: noTelp),
              ProfileInfo(label: 'Tanggal Lahir', value: tglLahir),
              ProfileInfo(label: 'Jenis Kelamin', value: jenisKelamin),
              const Divider(
                height: 20,
                color: Colors.grey,
              ),
              ElevatedButton(
                child: const Text('Edit Profil'),
                onPressed: () async {
                  pushUpdate(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushUpdate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UpdateProfilePage(),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String? value;

  const ProfileInfo({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'Tidak Tersedia',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
