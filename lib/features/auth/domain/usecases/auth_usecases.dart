import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (params.email.isEmpty || !emailRegex.hasMatch(params.email)) {
      return Future.value(
        const Left(Failure.unexpected('Please enter a valid email address')),
      );
    }
    if (params.password.length < 6) {
      return Future.value(
        const Left(Failure.unexpected('Password must be at least 6 characters')),
      );
    }
    if (!params.password.contains(RegExp(r'[A-Z]'))) {
      return Future.value(
        const Left(Failure.unexpected('Password must contain at least 1 uppercase letter')),
      );
    }
    if (!params.password.contains(RegExp(r'[a-z]'))) {
      return Future.value(
        const Left(Failure.unexpected('Password must contain at least 1 lowercase letter')),
      );
    }
    if (!params.password.contains(RegExp(r'[0-9]'))) {
      return Future.value(
        const Left(Failure.unexpected('Password must contain at least 1 number')),
      );
    }
    final specialCharRegex = RegExp(r'[\$#@_&!\*\^\-\+~]');
    if (!params.password.contains(specialCharRegex)) {
      return Future.value(
        const Left(Failure.unexpected('Password must contain at least 1 special character (\$, #, @, _, &, !, *, ^, -, +, ~)')),
      );
    }
    return repository.login(email: params.email, password: params.password);
  }
}

class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
