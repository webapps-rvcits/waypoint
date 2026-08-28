import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelexpense/app/locator.dart';
import 'package:travelexpense/features/auth/presentation/pages/login_page.dart';

/// Test Suite: LoginPage Widget Tests
/// Purpose: Verify UI rendering and initial state of the authentication screen.
/// Objective: Ensure that essential text elements (Welcome header, instructions)
/// are correctly rendered on screen when the app boots up in unauthenticated state.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    setupLocator();
  });

  testWidgets(
    'LoginPage renders welcome text',
    (WidgetTester tester) async {
      // Build the LoginPage inside a MaterialApp & ProviderScope harness
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      // Verify that primary branding and instruction titles are visible
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to log your trip spend'), findsOneWidget);
    },
  );
}
