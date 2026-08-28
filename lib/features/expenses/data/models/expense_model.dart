import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required double amount,
    @Default('USD') String currency,
    required String title,
    required String category,
    required String date,
    String? note,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  factory ExpenseModel.fromEntity(Expense entity) {
    return ExpenseModel(
      id: entity.id,
      amount: entity.amount,
      currency: entity.currency,
      title: entity.title,
      category: entity.category,
      date: entity.date.toIso8601String(),
      note: entity.note,
    );
  }
}
