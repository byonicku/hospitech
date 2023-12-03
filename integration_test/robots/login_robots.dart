// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginRobot {
  final WidgetTester tester;
  LoginRobot(this.tester);

  Future<void> login({String? username, String? password}) async {
    final usernameFormField = find.byKey(Key('Username'));
    final passwordFormField = find.byKey(Key('Password'));
    final loginBtn = find.byKey(Key("LoginBtn"));

    await tester.pumpAndSettle(Duration(seconds: 2));

    // test input username
    await tester.ensureVisible(usernameFormField);
    await tester.enterText(usernameFormField, username!);

    await tester.pumpAndSettle(Duration(seconds: 2));

    // test input password
    await tester.ensureVisible(passwordFormField);
    await tester.enterText(passwordFormField, password!);

    await tester.pumpAndSettle(Duration(seconds: 2));

    // test press login button
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);

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
