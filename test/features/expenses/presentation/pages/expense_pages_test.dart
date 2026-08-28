import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelexpense/app/locator.dart';
import 'package:travelexpense/features/expenses/domain/entities/expense.dart';
import 'package:travelexpense/features/expenses/presentation/pages/expense_detail_page.dart';
import 'package:travelexpense/features/expenses/presentation/pages/expense_form_page.dart';

/// Test Suite: Expenses Pages Widget Tests
/// Purpose: Test presentation page components for expense management.
/// Objective: Validate that ExpenseDetailPage displays complete expense details (title, amount, note)
/// and ExpenseFormPage correctly renders input fields and save trigger.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    locator.reset();
    setupLocator();
  });

  final testExpense = Expense(
    id: 'exp_100',
    amount: 150.0,
    currency: 'USD',
    title: 'Hotel stay',
    category: 'Lodging',
    date: DateTime(2026, 8, 28),
    note: 'Business trip',
  );

  group('Expenses Pages Widget Tests', () {
    /// Objective: Verify ExpenseDetailPage renders all detailed field values correctly.
    testWidgets('ExpenseDetailPage displays title, amount and note', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ExpenseDetailPage(expense: testExpense),
          ),
        ),
      );

      expect(find.text('Hotel stay'), findsOneWidget);
      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('Business trip'), findsOneWidget);
    });

    /// Objective: Verify ExpenseFormPage renders the form title and interactive Save button.
    testWidgets('ExpenseFormPage renders title field and save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExpenseFormPage(),
          ),
        ),
      );

      expect(find.text('New expense'), findsOneWidget);
      expect(find.byKey(const Key('expense_save_button')), findsOneWidget);
    });
  });
}
