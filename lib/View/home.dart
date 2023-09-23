import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/home_grid.dart';
import 'package:tugas_besar_hospital_pbp/View/profile_group.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Kategori Dokter Spesialis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: HomeGrid(),
      ),
    ),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile Group'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
