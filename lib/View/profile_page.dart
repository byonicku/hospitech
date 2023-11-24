import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:tugas_besar_hospital_pbp/View/update_profile_page.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
// import 'package:tugas_besar_hospital_pbp/database/sql_control.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  String? name, email, password, noTelp, tglLahir, jenisKelamin, imgPath;
  Image? _image;
  final picker = ImagePicker();

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // currentUser = await getUserByID(prefs.getInt('id'));
    currentUser = await UserClient.show(prefs.getString('id')!);
    setState(() {
      name = currentUser!.username;
      email = currentUser!.email;
      password = currentUser!.password;
      noTelp = currentUser!.noTelp;
      tglLahir = currentUser!.tglLahir;
      jenisKelamin = currentUser!.jenisKelamin;
      imgPath = currentUser!.profilePhoto;

      _image = imgPath == "" ? null : Image.file(File(imgPath!));
    });
  }

  Future<String> saveImageLocally(File imageFile) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await imageFile.copy(imagePath);

    return imagePath;
  }

  // fungsi ambil gambar profil dari galeri
  Future getImageFromGallery() async {
    picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((imgFile) async {
      // Uint8List? imgBytes = await imgFile!.readAsBytes();
      // String decodedToBase64 = Utility.toBase64String(imgBytes);

      File profileImage = File(imgFile!.path);
      String imagePath = await saveImageLocally(profileImage);

      User editDataUser = User(
          id: currentUser!.id,
          username: currentUser!.username,
          email: currentUser!.email,
          jenisKelamin: currentUser!.jenisKelamin,
          noTelp: currentUser!.noTelp,
          password: currentUser!.password,
          tglLahir: currentUser!.tglLahir,
          profilePhoto: imagePath);

      // editUser(editDataUser);
      UserClient.update(editDataUser);
      getUserData();
    });
  }

  //fungsi ambil gambar dari kamera
  Future getImageFromCamera() async {
    picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((imgCapture) async {
      File profileImage = File(imgCapture!.path);
      String imagePath = await saveImageLocally(profileImage);

      User editDataUser = User(
          id: currentUser!.id,
          username: currentUser!.username,
          email: currentUser!.email,
          jenisKelamin: currentUser!.jenisKelamin,
          noTelp: currentUser!.noTelp,
          password: currentUser!.password,
          tglLahir: currentUser!.tglLahir,
          profilePhoto: imagePath);

      // editUser(editDataUser);
      UserClient.update(editDataUser);
      getUserData();
    });
  }

  Future showPickImageOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              // tutup cupertino modalnya pake pop
              Navigator.of(context).pop();
              await getImageFromGallery();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.storage,
                  color: Colors.blue,
                ),
                Text("Gallery"),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              // tutup cupertino modalnya pake pop
              Navigator.of(context).pop();
              await getImageFromCamera();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera,
                  color: Colors.blue,
                ),
                Text("Camera"),
              ],
            ),
          ),
        ],
      ),
    );
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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: _image == null
                      ? const AssetImage('assets/images/profil.png')
                      : _image!.image,
                  child: Align(
                    alignment: const Alignment(0.8, 0.9),
                    child: InkWell(
                      onTap: () {
                        showPickImageOptions();
                      }, // Trigger image selection
                      child: Container(
                        width: 40, // Adjust the size as needed
                        height: 40, // Adjust the size as needed
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
