// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedCategoryFilterHash() =>
    r'a597f2ad4bdb8e09b190286e93ca0478a854d54c';

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
///
/// Copied from [SelectedCategoryFilter].
@ProviderFor(SelectedCategoryFilter)
final selectedCategoryFilterProvider =
    AutoDisposeNotifierProvider<SelectedCategoryFilter, String>.internal(
      SelectedCategoryFilter.new,
      name: r'selectedCategoryFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategoryFilter = AutoDisposeNotifier<String>;
String _$expenseListNotifierHash() =>
    r'6ae496ba3ff4e49f82a605b499bd9d1c11f1608a';

/// See also [ExpenseListNotifier].
@ProviderFor(ExpenseListNotifier)
final expenseListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ExpenseListNotifier,
      List<Expense>
    >.internal(
      ExpenseListNotifier.new,
      name: r'expenseListNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseListNotifier = AutoDisposeAsyncNotifier<List<Expense>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
