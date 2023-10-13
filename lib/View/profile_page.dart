import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
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
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/profil.png'),
                ),
                const SizedBox(height: 20),
                ProfileInfo(label: 'Username', value: name),
                ProfileInfo(label: 'Email', value: email),
                ProfileInfo(label: 'No. Telepon', value: noTelp),
                ProfileInfo(label: 'Tanggal Lahir', value: tglLahir),
                ProfileInfo(label: 'Jenis Kelamin', value: jenisKelamin),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    pushUpdate(context);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    pushLogout(context);

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('id');

                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil Melakukan Logout'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
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

  void pushLogout(BuildContext context) {
    FocusManager.instance.primaryFocus!.unfocus();

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String? value;

  const ProfileInfo({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'Tidak Tersedia',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
