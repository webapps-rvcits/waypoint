import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:travelexpense/features/expenses/data/models/expense_model.dart';
import 'package:travelexpense/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:travelexpense/features/expenses/domain/entities/expense.dart';

class MockExpenseRemoteDataSource extends Mock implements ExpenseRemoteDataSource {}

void main() {
  late MockExpenseRemoteDataSource mockRemoteDataSource;
  late ExpenseRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const ExpenseModel(
      id: '1',
      amount: 10.0,
      currency: 'USD',
      title: 'Coffee',
      category: 'Meals',
      date: '2026-08-28T00:00:00.000',
    ));
  });

  setUp(() {
    mockRemoteDataSource = MockExpenseRemoteDataSource();
    repository = ExpenseRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const testModel = ExpenseModel(
    id: 'exp_1',
    amount: 86.40,
    currency: 'USD',
    title: 'Client dinner',
    category: 'Meals',
    date: '2026-08-28T00:00:00.000',
  );

  final testEntity = Expense(
    id: 'exp_1',
    amount: 86.40,
    currency: 'USD',
    title: 'Client dinner',
    category: 'Meals',
    date: DateTime.parse('2026-08-28T00:00:00.000'),
  );

  group('ExpenseRepositoryImpl', () {
    test('getExpenses returns Right(List<Expense>) on success', () async {
      when(() => mockRemoteDataSource.fetchExpenses())
          .thenAnswer((_) async => [testModel]);

      final result = await repository.getExpenses();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (expenses) => expect(expenses.first.title, 'Client dinner'),
      );
    });

    test('addExpense converts entity to model and maps back on success', () async {
      when(() => mockRemoteDataSource.addExpense(any()))
          .thenAnswer((_) async => testModel);

      final result = await repository.addExpense(testEntity);

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.addExpense(any())).called(1);
    });
  });
}
