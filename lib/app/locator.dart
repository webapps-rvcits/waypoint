import 'package:get_it/get_it.dart';

import '../core/storage/token_storage.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/expenses/data/datasources/expense_remote_data_source.dart';
import '../features/expenses/data/repositories/expense_repository_impl.dart';
import '../features/expenses/domain/repositories/expense_repository.dart';
import '../features/expenses/domain/usecases/get_expenses_usecase.dart';

import '../features/expenses/data/datasources/hive_expense_remote_data_source.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Storage
  locator.registerLazySingleton<TokenStorage>(() => HiveTokenStorage());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => MockAuthRemoteDataSource());
  locator.registerLazySingleton<ExpenseRemoteDataSource>(
      () => HiveExpenseRemoteDataSource());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: locator(),
        tokenStorage: locator(),
      ));

  locator.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(remoteDataSource: locator()));

  // Use cases - Auth
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => GetCurrentUserUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));

  // Use cases - Expenses
  locator.registerLazySingleton(() => GetExpensesUseCase(locator()));
  locator.registerLazySingleton(() => AddExpenseUseCase(locator()));
  locator.registerLazySingleton(() => UpdateExpenseUseCase(locator()));
  locator.registerLazySingleton(() => DeleteExpenseUseCase(locator()));
}
