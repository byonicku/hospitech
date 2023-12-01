// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DaftarPeriksaRobot {
  final WidgetTester tester;
  DaftarPeriksaRobot(this.tester);

  Future<void> login({String? username, String? password}) async {
    final usernameFormField = find.byKey(Key('Username'));
    final passwordFormField = find.byKey(Key('Password'));
    final loginBtn = find.byKey(Key("LoginBtn"));

    await tester.pumpAndSettle();

    // test input username
    await tester.ensureVisible(usernameFormField);
    await tester.enterText(usernameFormField, username!);

    await tester.pumpAndSettle();

    // test input password
    await tester.ensureVisible(passwordFormField);
    await tester.enterText(passwordFormField, password!);

    await tester.pumpAndSettle();

    // test press login button
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);

    await tester.pumpAndSettle();
  }

  Future<void> addPeriksa({String? namaPasien, String? tglPeriksa}) async {
    final tabListPeriksa = find.byIcon(Icons.app_registration);
    final namaPasienFormField = find.byKey(Key('Nama Pasien'));
    final tglPeriksaFormField = find.byKey(Key('TglPeriksa'));
    final dokterDropdown = find.byKey(Key('Dokter Dropdown'));
    final jenisPerawatan = find.byKey(Key('Jenis Perawatan'));
    final daftarPeriksaBtn = find.byKey(Key('Daftar Periksa'));
    final sudahBtn = find.byKey(Key('SudahBtn'));
    // final belumBtn = find.byKey(Key('BelumBtn'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click to bottom navigation list periksa
    await tester.ensureVisible(tabListPeriksa);
    await tester.tap(tabListPeriksa);

    await tester.pumpAndSettle(Duration(seconds: 2));

    // click icon add untuk tambah periksa
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(Duration(seconds: 1));

    // test input nama pasien
    await tester.ensureVisible(namaPasienFormField);
    await tester.enterText(namaPasienFormField, namaPasien!);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test input tgl periksa
    await tester.ensureVisible(tglPeriksaFormField);
    await tester.tap(tglPeriksaFormField);

    await tester.pump(Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(find.byType(TextField).last, tglPeriksa!);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test dropdown dokter spesialis
    await tester.ensureVisible(dokterDropdown);
    await tester.tap(dokterDropdown);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text('Spesialis Paru - paru'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test dropdown jenis perawatan
    await tester.ensureVisible(jenisPerawatan);
    await tester.tap(jenisPerawatan);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byKey(Key('Rawat Jalan')));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click daftar periksa
    await tester.ensureVisible(daftarPeriksaBtn);
    await tester.tap(daftarPeriksaBtn);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click sudah untuk konfirmasi
    await tester.ensureVisible(sudahBtn);
    await tester.tap(sudahBtn);

    await tester.pumpAndSettle(Duration(seconds: 4));
  }

  Future<void> readPeriksa() async {
    final tabListPeriksa = find.byIcon(Icons.app_registration);
    await tester.pumpAndSettle(Duration(seconds: 1));

    // click to bottom navigation list periksa
    await tester.ensureVisible(tabListPeriksa);
    await tester.tap(tabListPeriksa);

    await tester.pumpAndSettle(Duration(seconds: 2));
  }

  Future<void> deletePeriksa() async {
    final tabListPeriksa = find.byIcon(Icons.app_registration);
    final deleteBtn = find.byKey(Key('DeleteBtn'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click to bottom navigation list periksa
    await tester.ensureVisible(tabListPeriksa);
    await tester.tap(tabListPeriksa);

    await tester.pumpAndSettle(Duration(seconds: 2));

    // klik icon delete periksa
    await tester.ensureVisible(deleteBtn);
    await tester.tap(deleteBtn);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click sudah untuk konfirmasi
    await tester.ensureVisible(find.text('Ya'));
    await tester.tap(find.text('Ya'));

    await tester.pumpAndSettle(Duration(seconds: 4));
  }

  Future<void> updatePeriksa({String? namaPasien, String? tglPeriksa}) async {
    final tabListPeriksa = find.byIcon(Icons.app_registration);
    final namaPasienFormField = find.byKey(Key('Nama Pasien'));
    final tglPeriksaFormField = find.byKey(Key('TglPeriksa'));
    final dokterDropdown = find.byKey(Key('Dokter Dropdown'));
    final jenisPerawatan = find.byKey(Key('Jenis Perawatan'));
    final daftarPeriksaBtn = find.byKey(Key('Edit Periksa'));
    final sudahBtn = find.byKey(Key('SudahBtn'));
    final editBtn = find.byKey(Key('EditBtn'));
    // final belumBtn = find.byKey(Key('BelumBtn'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click to bottom navigation list periksa
    await tester.ensureVisible(tabListPeriksa);
    await tester.tap(tabListPeriksa);

    await tester.pumpAndSettle(Duration(seconds: 2));

    // klik icon edit untuk update periksa
    await tester.ensureVisible(editBtn);
    await tester.tap(editBtn);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test input nama pasien
    await tester.ensureVisible(namaPasienFormField);
    await tester.enterText(namaPasienFormField, '');
    await tester.enterText(namaPasienFormField, namaPasien!);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test input tgl periksa
    await tester.ensureVisible(tglPeriksaFormField);
    await tester.tap(tglPeriksaFormField);

    await tester.pump(Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(find.byType(TextField).last, '');
    await tester.enterText(find.byType(TextField).last, tglPeriksa!);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test dropdown dokter spesialis
    await tester.ensureVisible(dokterDropdown);
    await tester.tap(dokterDropdown);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text('Spesialis Jantung'));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // test dropdown jenis perawatan
    await tester.ensureVisible(jenisPerawatan);
    await tester.tap(jenisPerawatan);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byKey(Key('Rawat Inap')));

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click daftar periksa
    await tester.ensureVisible(daftarPeriksaBtn);
    await tester.tap(daftarPeriksaBtn);

    await tester.pumpAndSettle(Duration(seconds: 1));

    // click sudah untuk konfirmasi
    await tester.ensureVisible(sudahBtn);
    await tester.tap(sudahBtn);

    await tester.pumpAndSettle(Duration(seconds: 4));
  }

  Future<void> logout() async {
    final profileTab = find.byIcon(Icons.person).first;

    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(profileTab);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.scrollUntilVisible(find.text('Logout'), 0.1,
        duration: Duration(seconds: 1));

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle(Duration(seconds: 2));
  }
}
