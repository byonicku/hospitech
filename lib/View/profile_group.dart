import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

SingleChildScrollView namePage(
  String url,
  String name,
  String tagline,
  String npm,
  String aboutMe,
  String contact,
) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.only(top: 1.0.h, left: 8.0.w, right: 8.0.w),
      child: SizedBox(
        child: Column(
          children: [
            Image(
              image: NetworkImage(url),
              width: 50.w,
              height: 50.h,
            ),
            Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            Text(tagline,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp)),
            Text(npm, style: TextStyle(fontSize: 14.sp)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("About Me:",
                  textAlign: TextAlign.justify,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
            Text(aboutMe,
                textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp)),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Contact:",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  contact,
                  style: TextStyle(fontSize: 14.sp),
                )),
          ],
        ),
      ),
    ),
  );
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text(
            "Developers",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person, size: 16.sp),
                text: "Nico",
                height: 5.h,
              ),
              Tab(
                icon: Icon(Icons.person, size: 16.sp),
                text: "Fredo",
                height: 5.h,
              ),
              Tab(
                icon: Icon(Icons.person, size: 16.sp),
                text: "Berly",
                height: 5.h,
              ),
              Tab(
                icon: Icon(Icons.person, size: 16.sp),
                text: "Hendry",
                height: 5.h,
              ),
              Tab(
                icon: Icon(Icons.person, size: 16.sp),
                text: "Anri",
                height: 5.h,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            namePage(
                "https://avatars.githubusercontent.com/u/82759105?v=4",
                "Nico Herlim",
                "Programming Enthusiast",
                "210711227",
                "I am a student at Universitas Atma Jaya Yogyakarta, majoring in Informatics. I am currently in my 5nd semester.",
                "nicoherlim@gmail.com"),
            namePage(
                "https://avatars.githubusercontent.com/u/128687596?v=4",
                "Boniface Fredo Ronan Antolino",
                "Programming Enthusiast",
                "210711446",
                "I am a student at Universitas Atma Jaya Yogyakarta, majoring in Informatics. I am currently in my 5nd semester.",
                "fredoronan@gmail.com"),
            namePage(
                "https://avatars.githubusercontent.com/u/144400221?v=4",
                "Genoveva Epifani Berly Anawang",
                "Programming Enthusiast",
                "210711491",
                "I am a student at Universitas Atma Jaya Yogyakarta, majoring in Informatics. I am currently in my 5nd semester.",
                "genovevaberlyg@gmail.com"),
            namePage(
                "https://avatars.githubusercontent.com/u/135349842?v=4",
                "Hendryanto",
                "Programming Enthusiast",
                "210711292",
                "I am a student at Universitas Atma Jaya Yogyakarta, majoring in Informatics. I am currently in my 5nd semester.",
                "hendryanto@gmail.com"),
            namePage(
                "https://avatars.githubusercontent.com/u/53933926?&v=4",
                "Andre Victory",
                "Programming Enthusiast",
                "210711025",
                "I am a student at Universitas Atma Jaya Yogyakarta, majoring in Informatics. I am currently in my 5nd semester.",
                "andrevictory@gmail.com"),
          ],
        ),
      ),
    );
  }
}
