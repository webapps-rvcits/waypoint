import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/expense_model.dart';

part 'expense.freezed.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required double amount,
    required String currency,
    required String title,
    required String category,
    required DateTime date,
    String? note,
  }) = _Expense;

  factory Expense.fromModel(ExpenseModel model) {
    return Expense(
      id: model.id,
      amount: model.amount,
      currency: model.currency,
      title: model.title,
      category: model.category,
      date: DateTime.tryParse(model.date) ?? DateTime.now(),
      note: model.note,
    );
  }
}
