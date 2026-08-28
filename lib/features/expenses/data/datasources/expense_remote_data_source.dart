import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> fetchExpenses();
  Future<ExpenseModel> addExpense(ExpenseModel model);
  Future<ExpenseModel> updateExpense(ExpenseModel model);
  Future<void> deleteExpense(String id);
}

class MockExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  final List<ExpenseModel> _items = [
    ExpenseModel(
      id: 'exp_1',
      amount: 86.40,
      currency: 'USD',
      title: 'Client dinner',
      category: 'Meals',
      date: DateTime.now().subtract(const Duration(days: 0)).toIso8601String(),
      note: 'Dinner with Acme Corp stakeholders',
    ),
    ExpenseModel(
      id: 'exp_2',
      amount: 42.00,
      currency: 'USD',
      title: 'Airport transfer',
      category: 'Transit',
      date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      note: 'Taxi to terminal 2',
    ),
    ExpenseModel(
      id: 'exp_3',
      amount: 412.00,
      currency: 'USD',
      title: 'Hotel — 2 nights',
      category: 'Lodging',
      date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      note: 'Grand Hyatt downtown',
    ),
    ExpenseModel(
      id: 'exp_4',
      amount: 14.10,
      currency: 'USD',
      title: 'Coffee, team sync',
      category: 'Meals',
      date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      note: 'Morning espresso shots',
    ),
    ExpenseModel(
      id: 'exp_5',
      amount: 125.00,
      currency: 'USD',
      title: 'Conference pass',
      category: 'Other',
      date: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      note: 'Tech Summit Day 1 ticket',
    ),
    ExpenseModel(
      id: 'exp_6',
      amount: 55.00,
      currency: 'USD',
      title: 'Rideshare to venue',
      category: 'Transit',
      date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    ),
    ExpenseModel(
      id: 'exp_7',
      amount: 32.50,
      currency: 'USD',
      title: 'Team lunch',
      category: 'Meals',
      date: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
    ),
    ExpenseModel(
      id: 'exp_8',
      amount: 499.00,
      currency: 'USD',
      title: 'Roundtrip flight',
      category: 'Transit',
      date: DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
      note: 'Economy flex ticket',
    ),
    ExpenseModel(
      id: 'exp_9',
      amount: 18.50,
      currency: 'USD',
      title: 'Airport snacks',
      category: 'Meals',
      date: DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
    ),
  ];

  @override
  Future<List<ExpenseModel>> fetchExpenses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_items);
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel model) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newModel = model.copyWith(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
    );
    _items.insert(0, newModel);
    return newModel;
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel model) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _items.indexWhere((e) => e.id == model.id);
    if (index != -1) {
      _items[index] = model;
      return model;
    }
    throw Exception('Expense not found');
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _items.removeWhere((e) => e.id == id);
  }
}
