// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RegisterRobot {
  final WidgetTester tester;
  RegisterRobot(this.tester);

  Future<void> registerCorrect({String? username, String? password, String? email}) async {
    final usernameFormField = find.byKey(Key('Username'));
    final emailFormField = find.byKey(Key('Email'));
    final passwordFormField = find.byKey(Key('Password'));
    final noTelpFormField = find.byKey(Key('No Telepon'));
    final tglLahirFormField = find.byKey(Key('TglLahir'));
    final genderCheckbox = find.byKey(Key('Gender'));
    final acceptTermsCheckbox = find.byKey(Key('AcceptTerms'));
    final registerBtn = find.byKey(Key('RegisterBtn'));
    final sudahBtn = find.byKey(Key('SudahBtn'));

    await tester.pumpAndSettle();

    // test input username
    await tester.ensureVisible(usernameFormField);
    await tester.enterText(usernameFormField, username!);

    await tester.pumpAndSettle();

    // test input email
    await tester.ensureVisible(emailFormField);
    await tester.enterText(emailFormField, email!);

    await tester.pumpAndSettle();

    // test input password
    await tester.ensureVisible(passwordFormField);
    await tester.enterText(passwordFormField, password!);

    await tester.pumpAndSettle();

    // test input noTelp
    await tester.ensureVisible(noTelpFormField);
    await tester.enterText(noTelpFormField, '087875647859');

    await tester.pumpAndSettle();

    // test input tglLahir
    await tester.ensureVisible(tglLahirFormField);
    await tester.tap(tglLahirFormField);
    await tester.pump();

    // expect(find.byType(DateTime), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.byType(TextField).last, '12/09/1996');
    await tester.pump();
    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    // test input gender checkbox
    await tester.ensureVisible(genderCheckbox);
    await tester.tap(find.text('Laki-Laki'));

    await tester.pumpAndSettle();

    // test input accept terms checkbox
    await tester.ensureVisible(acceptTermsCheckbox);
    await tester.tap(acceptTermsCheckbox);

    await tester.pumpAndSettle();

    // test press register button
    await tester.ensureVisible(registerBtn);
    await tester.tap(registerBtn);

    await tester.pumpAndSettle();

    // test press sudah button
    await tester.ensureVisible(sudahBtn);
    await tester.tap(sudahBtn);

    await tester.pumpAndSettle();
  }

  Future<void> tapRegister() async {
    final registerBtn = find.byKey(Key('RegisterBtn'));

    // test tap on register btn
    await tester.tap(registerBtn);
    await tester.pumpAndSettle();
  }
}
