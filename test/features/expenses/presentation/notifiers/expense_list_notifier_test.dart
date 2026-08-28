import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/app/locator.dart';
import 'package:travelexpense/core/error/failure.dart';
import 'package:travelexpense/core/usecases/usecase.dart';
import 'package:travelexpense/features/expenses/domain/entities/expense.dart';
import 'package:travelexpense/features/expenses/domain/usecases/get_expenses_usecase.dart';
import 'package:travelexpense/features/expenses/presentation/notifiers/expense_list_notifier.dart';

class MockGetExpensesUseCase extends Mock implements GetExpensesUseCase {}

class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}

class MockUpdateExpenseUseCase extends Mock implements UpdateExpenseUseCase {}

class MockDeleteExpenseUseCase extends Mock implements DeleteExpenseUseCase {}

/// Test Suite: ExpenseListNotifier Presentation Unit Tests
/// Purpose: Validate state transitions and use case invocations for expense list management.
void main() {
  late MockGetExpensesUseCase mockGetExpensesUseCase;
  late MockAddExpenseUseCase mockAddExpenseUseCase;
  late MockUpdateExpenseUseCase mockUpdateExpenseUseCase;
  late MockDeleteExpenseUseCase mockDeleteExpenseUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    locator.reset();
    mockGetExpensesUseCase = MockGetExpensesUseCase();
    mockAddExpenseUseCase = MockAddExpenseUseCase();
    mockUpdateExpenseUseCase = MockUpdateExpenseUseCase();
    mockDeleteExpenseUseCase = MockDeleteExpenseUseCase();

    locator.registerLazySingleton<GetExpensesUseCase>(() => mockGetExpensesUseCase);
    locator.registerLazySingleton<AddExpenseUseCase>(() => mockAddExpenseUseCase);
    locator.registerLazySingleton<UpdateExpenseUseCase>(() => mockUpdateExpenseUseCase);
    locator.registerLazySingleton<DeleteExpenseUseCase>(() => mockDeleteExpenseUseCase);
  });

  final testExpense = Expense(
    id: '1',
    amount: 50.0,
    currency: 'USD',
    title: 'Lunch',
    category: 'Meals',
    date: DateTime.now(),
  );

  group('ExpenseListNotifier', () {
    // Purpose: Validate that ExpenseListNotifier correctly fetches and resolves expenses from GetExpensesUseCase into state.
    test('ExpenseListNotifier loads list of expenses successfully', () async {
      when(() => mockGetExpensesUseCase(any()))
          .thenAnswer((_) async => Right([testExpense]));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final expenses = await container.read(expenseListNotifierProvider.future);

      expect(expenses.length, 1);
      expect(expenses.first.title, 'Lunch');
      verify(() => mockGetExpensesUseCase(any())).called(1);
    });

    // Purpose: Validate error propagation when GetExpensesUseCase returns a Left failure.
    test('ExpenseListNotifier throws exception when GetExpensesUseCase fails', () async {
      when(() => mockGetExpensesUseCase(any()))
          .thenAnswer((_) async => const Left(Failure.serverError('Server failure')));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(expenseListNotifierProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
