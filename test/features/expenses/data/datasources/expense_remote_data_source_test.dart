import 'package:flutter_test/flutter_test.dart';
import 'package:travelexpense/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:travelexpense/features/expenses/data/models/expense_model.dart';

void main() {
  late MockExpenseRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockExpenseRemoteDataSource();
  });

  group('MockExpenseRemoteDataSource', () {
    test('fetchExpenses returns initial seeded list of expenses', () async {
      final items = await dataSource.fetchExpenses();
      expect(items.length, greaterThanOrEqualTo(9));
      expect(items.first.title, 'Client dinner');
    });

    test('addExpense inserts item at beginning of list', () async {
      const newModel = ExpenseModel(
        id: '',
        amount: 25.0,
        currency: 'USD',
        title: 'Taxi',
        category: 'Transit',
        date: '2026-08-28T00:00:00.000',
      );

      final saved = await dataSource.addExpense(newModel);
      expect(saved.id, startsWith('exp_'));
      expect(saved.title, 'Taxi');

      final items = await dataSource.fetchExpenses();
      expect(items.first.title, 'Taxi');
    });
  });
}
