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

    testWidgets('Register Test', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      registerRobot = RegisterRobot(tester);

      await registerRobot.tapRegister();
      await registerRobot.registerCorrect(
          username: 'User 5', password: 'password5', email: 'user5@gmail.com');
    });

    testWidgets('List Periksa', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      daftarPeriksaRobot = DaftarPeriksaRobot(tester);

      await daftarPeriksaRobot.login(username: 'User 4', password: 'password4');
      await daftarPeriksaRobot.addPeriksa(
          namaPasien: 'Pasien Baru', tglPeriksa: '12/04/2023');
    });
  });
}
