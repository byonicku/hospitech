import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:tugas_besar_hospital_pbp/View/update_profile_page.dart';
import 'package:tugas_besar_hospital_pbp/database/user_client.dart';
import 'package:tugas_besar_hospital_pbp/entity/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tugas_besar_hospital_pbp/database/constant.dart';

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
  bool _isLoading = true;
  static const String endpoint = '/storage/user/';

  void getUserData() async {
    _isLoading = true;
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
      _image = imgPath == ""
          ? const Image(
              image: AssetImage('assets/images/profil.png'),
            )
          : Image.network(
              'http://$url$endpoint${imgPath!}',
            );

      _isLoading = false;
    });
  }

  Future<String> convertToBase64(File imageFile) async {
    Uint8List imgBytes = await imageFile.readAsBytes();
    return base64.encode(imgBytes);
  }

  // fungsi ambil gambar profil dari galeri
  Future getImageFromGallery() async {
    picker
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    )
        .then((imgFile) async {
      File profileImage = File(imgFile!.path);
      String imagePath = await convertToBase64(profileImage);
      int? id = currentUser!.id;

      // editUser(editDataUser);
      UserClient.updatePhotoProfil(id, imagePath);
    });
  }

  //fungsi ambil gambar dari kamera
  Future getImageFromCamera() async {
    picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((imgCapture) async {
      File profileImage = File(imgCapture!.path);
      String imagePath = await convertToBase64(profileImage);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.storage,
                  color: Colors.blue,
                  size: 18.sp,
                ),
                Text(
                  "Gallery",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              // tutup cupertino modalnya pake pop
              Navigator.of(context).pop();
              await getImageFromCamera();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera,
                  color: Colors.blue,
                  size: 18.sp,
                ),
                Text(
                  "Camera",
                  style: TextStyle(fontSize: 18.sp),
                ),
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
        title: Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 15.w,
                        backgroundImage: _image == null
                            ? const AssetImage('assets/images/profil.png')
                            : _image!.image,
                        child: Align(
                          alignment: const Alignment(0.8, 0.9),
                          child: InkWell(
                            onTap: () {
                              showPickImageOptions();
                            }, // Trigger image selection
                            onTapCancel: () => getUserData(),
                            child: Container(
                              width: 10.w, // Adjust the size as needed
                              height: 6.h, // Adjust the size as needed
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
                      SizedBox(height: 3.h),
                      ProfileInfo(label: 'Username', value: name),
                      ProfileInfo(label: 'Email', value: email),
                      ProfileInfo(label: 'No. Telepon', value: noTelp),
                      ProfileInfo(label: 'Tanggal Lahir', value: tglLahir),
                      ProfileInfo(label: 'Jenis Kelamin', value: jenisKelamin),
                      SizedBox(height: 3.h),
                      ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.h, vertical: 2.0.w),
                          child: Text(
                            'Edit Profile',
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          pushUpdate(context);
                        },
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.h, vertical: 2.0.w),
                          child: Text(
                            'Logout',
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
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
            )
          : const Center(
              child: CircularProgressIndicator(),
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
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'Tidak Tersedia',
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
}
