import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/features/auth/domain/entities/user.dart';
import 'package:travelexpense/features/auth/domain/repositories/auth_repository.dart';
import 'package:travelexpense/features/auth/domain/usecases/auth_usecases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const testUser = User(
    id: '1',
    email: 'test@waypoint.com',
    name: 'Test User',
    token: 'token123',
  );

  group('LoginUseCase', () {
    test('should return Failure when email format is invalid', () async {
      final result = await loginUseCase(
        const LoginParams(email: 'invalidemail', password: 'Pass@123'),
      );

      expect(result.isLeft(), true);
      verifyNever(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('should return UserModel when credentials are valid', () async {
      when(() => mockAuthRepository.login(
            email: 'test@waypoint.com',
            password: 'Pass@123',
          )).thenAnswer((_) async => const Right(testUser));

      final result = await loginUseCase(
        const LoginParams(
          email: 'test@waypoint.com',
          password: 'Pass@123',
        ),
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (user) => expect(user.email, 'test@waypoint.com'),
      );
    });
  });
}
