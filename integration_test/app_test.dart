import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tugas_besar_hospital_pbp/main.dart' as app;

import 'robots/daftar_periksa_robot.dart';
import 'robots/login_robots.dart';
import 'robots/register_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  RegisterRobot registerRobot;
  LoginRobot loginRobot;
  DaftarPeriksaRobot daftarPeriksaRobot;

  group('Integration Test | ', () {
    testWidgets('Login Test', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      loginRobot = LoginRobot(tester);

      await loginRobot.login(username: 'User 4', password: 'password4');
      await loginRobot.logout();
    });

    testWidgets('Login Fail 1 Test', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      loginRobot = LoginRobot(tester);

      await loginRobot.login(username: 'xxx', password: 'xxx');

      expect(find.text('Anda belum terdaftar sebagai user!'), findsOneWidget);
    });

    testWidgets('Login Fail 2 Test', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      loginRobot = LoginRobot(tester);

      await loginRobot.login(username: 'User 4', password: 'xxx');

      expect(find.text('Username atau password yang Anda masukkan salah'),
          findsOneWidget);
    });

    testWidgets('Register Test', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      registerRobot = RegisterRobot(tester);

      await registerRobot.tapRegister();
      await registerRobot.registerCorrect(
          username: 'User 5', password: 'password5', email: 'user5@gmail.com');
    });

    testWidgets('Create List Periksa', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      daftarPeriksaRobot = DaftarPeriksaRobot(tester);

      await daftarPeriksaRobot.login(username: 'User 4', password: 'password4');
      await daftarPeriksaRobot.addPeriksa(
          namaPasien: 'Pasien Baru', tglPeriksa: '12/04/2023');
    });

    testWidgets('Read List Periksa', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      daftarPeriksaRobot = DaftarPeriksaRobot(tester);

      await daftarPeriksaRobot.login(username: 'User 4', password: 'password4');
      expect(find.text('Pasien Baru'), findsOneWidget);
      expect(find.byWidget(Card()), findsOneWidget);
    });

    testWidgets('Update List Periksa', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      daftarPeriksaRobot = DaftarPeriksaRobot(tester);

      await daftarPeriksaRobot.login(username: 'User 4', password: 'password4');
      await daftarPeriksaRobot.updatePeriksa(
          namaPasien: 'Pasien Lama', tglPeriksa: '13/04/2023');
      expect(find.text('Pasien Lama'), findsOneWidget);
      expect(find.text('13/04/2023'), findsOneWidget);
      expect(find.text('Rawat Inap'), findsOneWidget);
      expect(find.text('Spesialis Jantung'), findsOneWidget);
      expect(find.byWidget(Card()), findsOneWidget);
    });

    testWidgets('Delete List Periksa', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      daftarPeriksaRobot = DaftarPeriksaRobot(tester);

      await daftarPeriksaRobot.login(username: 'User 4', password: 'password4');
      await daftarPeriksaRobot.deletePeriksa();
      expect(find.text('Berhasil Menghapus Data'), findsOneWidget);
    });
  });
}
