import 'package:flutter/material.dart';
import 'package:tugas_besar_hospital_pbp/View/home.dart';
import 'package:tugas_besar_hospital_pbp/View/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? id = prefs.getString('id') ?? '';

  runApp(MainApp(id: id));
}

// Event handling untuk dark mode, kalo butuh check sekarang dark mode atau engga
// bisa pake darkNotifier.value dan include main.dart
final darkNotifier = ValueNotifier<bool>(false);

class MainApp extends StatelessWidget {
  final String? id;
  const MainApp({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkNotifier,
        builder: (BuildContext context, bool isDark, Widget? child) {
          return ResponsiveSizer(builder: (context, orientation, deviceType) {
            Device.orientation == Orientation.portrait
                ? SizedBox(
                    width: 100.w,
                    height: 20.5.h,
                  )
                : SizedBox(
                    width: 100.w,
                    height: 12.5.h,
                  );
            Device.orientation == ScreenType.tablet
                ? SizedBox(
                    width: 100.w,
                    height: 20.5.h,
                  )
                : SizedBox(
                    width: 100.w,
                    height: 12.5.h,
                  );
            return MaterialApp(
              title: "Hospital PBP",
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                brightness: Brightness.light,
                colorSchemeSeed: Colors.blue,
                tabBarTheme: TabBarTheme(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.blue,
                  overlayColor: MaterialStateProperty.all(Colors.blue[50]),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.blue[50],
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorSchemeSeed: Colors.indigo,
                tabBarTheme: TabBarTheme(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.indigo,
                  overlayColor: MaterialStateProperty.all(Colors.indigo[900]),
                  labelColor: Colors.indigo,
                  unselectedLabelColor: Colors.grey,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: Colors.indigo[300],
                  unselectedItemColor: Colors.grey,
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.indigo,
                ),
                useMaterial3: true,
              ),
              // ignore: prefer_const_constructors
              home: id!.isEmpty
                  ? LoginView()
                  : HomeView(
                      selectedIndex:
                          0), // jangan di const ntah kenapa bikin error :v
            );
          });
        });
  }
}
