import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travelexpense/app/locator.dart';
import 'package:travelexpense/features/auth/presentation/pages/login_page.dart';

/// Test Suite: LoginPage Widget Tests
/// Purpose: Verify UI rendering and initial state of the authentication screen.
/// Objective: Ensure that essential text elements (Welcome header, instructions)
/// are correctly rendered on screen when the app boots up in unauthenticated state.
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_login_test_');
    Hive.init(tempDir.path);
    setupLocator();
  });

  tearDown(() async {
    await Hive.close();
    locator.reset();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets(
    'LoginPage renders welcome text',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to log your trip spend'), findsOneWidget);
    },
  );
}
