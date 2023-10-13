import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/home_grid.dart';
import 'package:tugas_besar_hospital_pbp/View/list_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/profile_group.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.selectedIndex});

  final int? selectedIndex;

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

  void setSelectedIndex(int index) {
    _selectedIndex = index;
  }

  @override
  void initState() {
    setSelectedIndex(widget.selectedIndex!);
    super.initState();
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
    const ListPeriksaView(),
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
          BottomNavigationBarItem(
              icon: Icon(
                Icons.app_registration,
              ),
              label: 'List periksa'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
