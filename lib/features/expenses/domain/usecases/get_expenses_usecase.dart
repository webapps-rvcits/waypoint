import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase implements UseCase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) {
    return repository.getExpenses();
  }
}

class AddExpenseParams {
  final Expense expense;

  const AddExpenseParams(this.expense);
}

class AddExpenseUseCase implements UseCase<Expense, AddExpenseParams> {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, Expense>> call(AddExpenseParams params) {
    final expense = params.expense;
    if (expense.amount <= 0) {
      return Future.value(const Left(Failure.unexpected('Amount must be greater than zero')));
    }
    if (expense.title.trim().isEmpty) {
      return Future.value(const Left(Failure.unexpected('Title is required')));
    }
    if (expense.category.trim().isEmpty) {
      return Future.value(const Left(Failure.unexpected('Category is required')));
    }
    return repository.addExpense(expense);
  }
}

class UpdateExpenseParams {
  final Expense expense;

  const UpdateExpenseParams(this.expense);
}

class UpdateExpenseUseCase implements UseCase<Expense, UpdateExpenseParams> {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, Expense>> call(UpdateExpenseParams params) {
    final expense = params.expense;
    if (expense.amount <= 0) {
      return Future.value(const Left(Failure.unexpected('Amount must be greater than zero')));
    }
    return repository.updateExpense(expense);
  }
}

class DeleteExpenseParams {
  final String id;

  const DeleteExpenseParams(this.id);
}

class DeleteExpenseUseCase implements UseCase<void, DeleteExpenseParams> {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteExpenseParams params) {
    return repository.deleteExpense(params.id);
  }
}
