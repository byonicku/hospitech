import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Column(
          children: [
            Image(
              image: NetworkImage(url),
              width: 200,
              height: 200,
            ),
            Text(name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(tagline),
            Text(npm),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("About Me:",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text(aboutMe),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Contact:",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  contact,
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
          title: const Text(
            "Profile Group",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
                text: "Nico",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Fredo",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Berly",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Hendry",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Anri",
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
