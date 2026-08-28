import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import 'expense_remote_data_source.dart';

class HiveExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  static const _boxName = 'expenses_box';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  List<ExpenseModel> _initialSeededExpenses() {
    final now = DateTime.now();
    return [
      ExpenseModel(
        id: 'exp_1',
        amount: 86.40,
        currency: 'USD',
        title: 'Client dinner',
        category: 'Meals',
        date: now.subtract(const Duration(days: 0)).toIso8601String(),
        note: 'Dinner with Acme Corp stakeholders',
      ),
      ExpenseModel(
        id: 'exp_2',
        amount: 42.00,
        currency: 'USD',
        title: 'Airport transfer',
        category: 'Transit',
        date: now.subtract(const Duration(days: 1)).toIso8601String(),
        note: 'Taxi to terminal 2',
      ),
      ExpenseModel(
        id: 'exp_3',
        amount: 412.00,
        currency: 'USD',
        title: 'Hotel — 2 nights',
        category: 'Lodging',
        date: now.subtract(const Duration(days: 2)).toIso8601String(),
        note: 'Grand Hyatt downtown',
      ),
      ExpenseModel(
        id: 'exp_4',
        amount: 14.10,
        currency: 'USD',
        title: 'Coffee, team sync',
        category: 'Meals',
        date: now.subtract(const Duration(days: 2)).toIso8601String(),
        note: 'Morning espresso shots',
      ),
      ExpenseModel(
        id: 'exp_5',
        amount: 125.00,
        currency: 'USD',
        title: 'Conference pass',
        category: 'Other',
        date: now.subtract(const Duration(days: 3)).toIso8601String(),
        note: 'Tech Summit Day 1 ticket',
      ),
      ExpenseModel(
        id: 'exp_6',
        amount: 55.00,
        currency: 'USD',
        title: 'Rideshare to venue',
        category: 'Transit',
        date: now.subtract(const Duration(days: 4)).toIso8601String(),
      ),
      ExpenseModel(
        id: 'exp_7',
        amount: 32.50,
        currency: 'USD',
        title: 'Team lunch',
        category: 'Meals',
        date: now.subtract(const Duration(days: 5)).toIso8601String(),
      ),
      ExpenseModel(
        id: 'exp_8',
        amount: 499.00,
        currency: 'USD',
        title: 'Roundtrip flight',
        category: 'Transit',
        date: now.subtract(const Duration(days: 6)).toIso8601String(),
        note: 'Economy flex ticket',
      ),
      ExpenseModel(
        id: 'exp_9',
        amount: 18.50,
        currency: 'USD',
        title: 'Airport snacks',
        category: 'Meals',
        date: now.subtract(const Duration(days: 6)).toIso8601String(),
      ),
    ];
  }

  @override
  Future<List<ExpenseModel>> fetchExpenses() async {
    final box = await _getBox();
    if (box.isEmpty) {
      final initial = _initialSeededExpenses();
      for (final model in initial) {
        await box.put(model.id, model.toJson());
      }
    }

    final rawList = box.values.toList();
    final items = rawList
        .map((e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    items.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    return items;
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel model) async {
    final box = await _getBox();
    final newModel = model.copyWith(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
    );
    await box.put(newModel.id, newModel.toJson());
    return newModel;
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel model) async {
    final box = await _getBox();
    if (box.containsKey(model.id)) {
      await box.put(model.id, model.toJson());
      return model;
    }
    throw Exception('Expense not found');
  }

  @override
  Future<void> deleteExpense(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
