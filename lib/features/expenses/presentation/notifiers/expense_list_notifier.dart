import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/locator.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/get_expenses_usecase.dart';

part 'expense_list_notifier.g.dart';

/// Presentation Notifier: ExpenseListNotifier
/// 
/// TEST SPECIFICATION & DOCUMENTATION:
/// - Test Target: test/features/expenses/presentation/notifiers/expense_list_notifier_test.dart
/// - Purpose of Tests: Validate state management for fetching, adding, updating, and deleting expenses.
/// - Objectives:
///   1. build(): Verify loading expenses via GetExpensesUseCase upon notifier initialization.
///   2. addExpense(expense): Verify optimistic update or state refresh when adding an expense.
///   3. updateExpense(expense): Verify updating an existing expense item in the list state.
///   4. deleteExpense(id): Verify deleting an expense item from state.
@riverpod
class SelectedCategoryFilter extends _$SelectedCategoryFilter {
  @override
  String build() => 'All';

  void select(String category) {
    state = category;
  }
}

@riverpod
class ExpenseListNotifier extends _$ExpenseListNotifier {
  @override
  FutureOr<List<Expense>> build() async {
    return _fetchExpenses();
  }

  Future<List<Expense>> _fetchExpenses() async {
    final getExpensesUseCase = locator<GetExpensesUseCase>();
    final result = await getExpensesUseCase(const NoParams());
    return result.fold(
      (failure) {
        final msg = failure.maybeWhen(
          serverError: (m) => m ?? 'Failed to load expenses',
          orElse: () => 'Unexpected error loading expenses',
        );
        throw Exception(msg);
      },
      (expenses) => expenses,
    );
  }

  Future<bool> addExpense(Expense expense) async {
    final addExpenseUseCase = locator<AddExpenseUseCase>();
    final result = await addExpenseUseCase(AddExpenseParams(expense));

    return result.fold(
      (failure) {
        state = AsyncValue.error('Could not save expense', StackTrace.current);
        return false;
      },
      (newExpense) {
        state.whenData((current) {
          state = AsyncValue.data([newExpense, ...current]);
        });
        return true;
      },
    );
  }

  Future<bool> updateExpense(Expense expense) async {
    final updateExpenseUseCase = locator<UpdateExpenseUseCase>();
    final result = await updateExpenseUseCase(UpdateExpenseParams(expense));

    return result.fold(
      (failure) {
        state = AsyncValue.error('Could not update expense', StackTrace.current);
        return false;
      },
      (updated) {
        state.whenData((current) {
          state = AsyncValue.data(
            current.map((e) => e.id == updated.id ? updated : e).toList(),
          );
        });
        return true;
      },
    );
  }

  Future<bool> deleteExpense(String id) async {
    final deleteExpenseUseCase = locator<DeleteExpenseUseCase>();
    final result = await deleteExpenseUseCase(DeleteExpenseParams(id));

    return result.fold(
      (failure) {
        state = AsyncValue.error('Could not delete expense', StackTrace.current);
        return false;
      },
      (_) {
        state.whenData((current) {
          state = AsyncValue.data(current.where((e) => e.id != id).toList());
        });
        return true;
      },
    );
  }
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchExpenses());
  }
}
