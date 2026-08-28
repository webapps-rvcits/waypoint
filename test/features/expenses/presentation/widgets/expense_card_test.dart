import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelexpense/features/expenses/domain/entities/expense.dart';
import 'package:travelexpense/features/expenses/presentation/widgets/expense_card.dart';

/// Test Suite: ExpenseCard Widget Tests
/// Purpose: Test individual reusable presentation components.
/// Objective: Validate that the ExpenseCard widget properly formats and displays
/// an Expense entity's title, category badge, and monetary amount formatted as USD currency.
void main() {
  final testExpense = Expense(
    id: 'exp_1',
    amount: 86.40,
    currency: 'USD',
    title: 'Client dinner',
    category: 'Meals',
    date: DateTime(2026, 8, 28),
  );

  group('ExpenseCard Widget Tests', () {
    /// Objective: Verify that ExpenseCard correctly reflects the entity attributes in the list row layout.
    testWidgets('ExpenseCard renders title, category, and formatted amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseCard(expense: testExpense),
          ),
        ),
      );

      expect(find.text('Client dinner'), findsOneWidget);
      expect(find.text('\$86.40'), findsOneWidget);
      expect(find.textContaining('Meals'), findsOneWidget);
    });
  });
}
