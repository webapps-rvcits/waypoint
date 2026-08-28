import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/core/storage/token_storage.dart';
import 'package:travelexpense/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:travelexpense/features/auth/data/models/user_model.dart';
import 'package:travelexpense/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      tokenStorage: mockTokenStorage,
    );
  });

  const testUserModel = UserModel(
    id: '1',
    email: 'test@company.com',
    name: 'Test',
    token: 'jwt_token',
  );

  group('AuthRepositoryImpl', () {
    test('login returns Right(User) and saves token on success', () async {
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => testUserModel);
      when(() => mockTokenStorage.saveToken(any()))
          .thenAnswer((_) async => {});

      final result = await repository.login(
        email: 'test@company.com',
        password: 'password123',
      );

      expect(result.isRight(), true);
      verify(() => mockTokenStorage.saveToken('jwt_token')).called(1);
    });

    test('login returns Left(Failure.unauthorized) when datasource throws', () async {
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      final result = await repository.login(
        email: 'wrong@company.com',
        password: 'wrong',
      );

      expect(result.isLeft(), true);
    });

    test('logout deletes token', () async {
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async => {});

      final result = await repository.logout();

      expect(result.isRight(), true);
      verify(() => mockTokenStorage.deleteToken()).called(1);
    });
  });
}
