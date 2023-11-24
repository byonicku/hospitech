import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/home_grid.dart';
import 'package:tugas_besar_hospital_pbp/View/list_periksa.dart';
import 'package:tugas_besar_hospital_pbp/View/profile_group.dart';
import 'package:tugas_besar_hospital_pbp/View/profile_page.dart';
import 'dart:io';
import 'dart:math';
import 'package:shake/shake.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.selectedIndex});

  final int? selectedIndex;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<String> dailyTips = [
    'Drink plenty of water',
    'Get enough sleep',
    'Take breaks from screen time',
    'Eat a balanced diet',
    'Exercise regularly',
    'Practice mindfulness',
    'Read a book',
    'Learn something new',
    'Tetap hidup walaupun berat'
  ];

  String selectedTip = '';
  bool currentShow = true;

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
    selectedTip = dailyTips[Random().nextInt(dailyTips.length)];
    ShakeDetector.autoStart(onPhoneShake: () => showTipDialog());
  }

  void showTipDialog() {
    if (!currentShow) {
      return;
    }

    setState(() {
      selectedTip = dailyTips[Random().nextInt(dailyTips.length)];
      currentShow = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Daily Tip', style: TextStyle(fontSize: 14.sp)),
          content: Text(
            selectedTip,
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(fontSize: 14.sp)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentShow = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text(
            "Kategori Dokter Spesialis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        body: HomeGrid(),
      ),
    ),
    const ProfilePage(),
    const ListPeriksaView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return FlutterCloseAppPage(
      interval: 2,
      condition: true,
      onCloseFailed: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Press back again to exit the application'),
        ));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 16.sp,
          unselectedFontSize: 14.sp,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.app_registration,
                ),
                label: 'List Periksa'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Developers'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

class FlutterCloseAppPage extends StatefulWidget {
  const FlutterCloseAppPage({
    Key? key,
    required this.child,
    this.interval = 2,
    this.condition = true,
    this.onCloseFailed,
  }) : super(key: key);

  /// The widget to wrap.
  final Widget child;

  /// The interval in seconds to close the app.
  final int interval;

  /// The custom condition to close the app.
  final bool condition;

  /// The callback when the condition is failed.
  final VoidCallback? onCloseFailed;

  @override
  State<FlutterCloseAppPage> createState() => _FlutterCloseAppPageState();
}

class _FlutterCloseAppPageState extends State<FlutterCloseAppPage> {
  int lastTime = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!Platform.isAndroid) {
          return true;
        }
        int diff = DateTime.now().second - lastTime;
        if (widget.condition && diff >= 0 && diff <= widget.interval) {
          return true;
        } else {
          lastTime = DateTime.now().second;
          widget.onCloseFailed?.call();
          return false;
        }
      },
      child: widget.child,
    );
  }
}
