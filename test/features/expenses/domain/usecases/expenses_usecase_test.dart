import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/core/error/failure.dart';
import 'package:travelexpense/core/usecases/usecase.dart';
import 'package:travelexpense/features/expenses/domain/entities/expense.dart';
import 'package:travelexpense/features/expenses/domain/repositories/expense_repository.dart';
import 'package:travelexpense/features/expenses/domain/usecases/get_expenses_usecase.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late MockExpenseRepository mockRepository;
  late GetExpensesUseCase getExpensesUseCase;
  late AddExpenseUseCase addExpenseUseCase;

  setUpAll(() {
    registerFallbackValue(Expense(
      id: 'fake',
      amount: 1.0,
      currency: 'USD',
      title: 'fake',
      category: 'Meals',
      date: DateTime.now(),
    ));
  });

  setUp(() {
    mockRepository = MockExpenseRepository();
    getExpensesUseCase = GetExpensesUseCase(mockRepository);
    addExpenseUseCase = AddExpenseUseCase(mockRepository);
  });

  final testExpense = Expense(
    id: 'exp_1',
    amount: 86.40,
    currency: 'USD',
    title: 'Client dinner',
    category: 'Meals',
    date: DateTime.now(),
  );

  group('GetExpensesUseCase', () {
    test('should return list of expenses from repository when successful', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => Right([testExpense]));

      final result = await getExpensesUseCase(const NoParams());

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (expenses) {
          expect(expenses.length, 1);
          expect(expenses.first.title, 'Client dinner');
        },
      );
      verify(() => mockRepository.getExpenses()).called(1);
    });

    test('should return Failure when repository fails', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => const Left(Failure.serverError('Server error')));

      final result = await getExpensesUseCase(const NoParams());

      expect(result.isLeft(), true);
      verify(() => mockRepository.getExpenses()).called(1);
    });
  });

  group('AddExpenseUseCase', () {
    test('should return Left Failure when amount is <= 0', () async {
      final invalidExpense = testExpense.copyWith(amount: 0.0);

      final result = await addExpenseUseCase(AddExpenseParams(invalidExpense));

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Should be Left'),
      );
      verifyNever(() => mockRepository.addExpense(any()));
    });

    test('should call repository.addExpense when data is valid', () async {
      when(() => mockRepository.addExpense(any()))
          .thenAnswer((_) async => Right(testExpense));

      final result = await addExpenseUseCase(AddExpenseParams(testExpense));

      expect(result.isRight(), true);
      verify(() => mockRepository.addExpense(any())).called(1);
    });
  });
}
