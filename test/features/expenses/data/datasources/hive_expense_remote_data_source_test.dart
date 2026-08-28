import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travelexpense/features/expenses/data/datasources/hive_expense_remote_data_source.dart';
import 'package:travelexpense/features/expenses/data/models/expense_model.dart';

void main() {
  late HiveExpenseRemoteDataSource dataSource;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_expense_ds_test_');
    Hive.init(tempDir.path);
    dataSource = HiveExpenseRemoteDataSource();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveExpenseRemoteDataSource', () {
    test('fetchExpenses seeds initial list on first launch', () async {
      final items = await dataSource.fetchExpenses();
      expect(items.length, greaterThanOrEqualTo(9));
      expect(items.any((e) => e.title == 'Client dinner'), true);
    });

    test('addExpense saves item into Hive box and returns it', () async {
      const newModel = ExpenseModel(
        id: '',
        amount: 35.0,
        currency: 'USD',
        title: 'Taxi to hotel',
        category: 'Transit',
        date: '2026-08-28T00:00:00.000',
      );

      final saved = await dataSource.addExpense(newModel);
      expect(saved.id, startsWith('exp_'));
      expect(saved.title, 'Taxi to hotel');

      final items = await dataSource.fetchExpenses();
      expect(items.first.title, 'Taxi to hotel');
    });

    test('deleteExpense removes item from Hive box', () async {
      final items = await dataSource.fetchExpenses();
      final targetId = items.first.id;

      await dataSource.deleteExpense(targetId);
      final updatedList = await dataSource.fetchExpenses();
      expect(updatedList.any((e) => e.id == targetId), false);
    });
  });
}
