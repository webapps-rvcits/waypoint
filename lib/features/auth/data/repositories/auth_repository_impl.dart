import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  User? _cachedUser;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      if (userModel.token != null) {
        await tokenStorage.saveToken(userModel.token!);
      }
      _cachedUser = userModel.toEntity();
      return Right(_cachedUser!);
    } catch (e) {
      return Left(Failure.unauthorized(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        return const Right(null);
      }
      if (_cachedUser != null) {
        return Right(_cachedUser);
      }
      _cachedUser = const User(
        id: 'usr_active',
        email: 'user@waypoint.com',
        name: 'Alex Traveler',
        token: 'mock_jwt_token',
      );
      return Right(_cachedUser);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenStorage.deleteToken();
      _cachedUser = null;
      return const Right(null);
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
