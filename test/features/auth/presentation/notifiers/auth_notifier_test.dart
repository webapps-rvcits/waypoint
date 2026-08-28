import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travelexpense/app/locator.dart';
import 'package:travelexpense/core/error/failure.dart';
import 'package:travelexpense/core/usecases/usecase.dart';
import 'package:travelexpense/features/auth/domain/entities/user.dart';
import 'package:travelexpense/features/auth/domain/usecases/auth_usecases.dart';
import 'package:travelexpense/features/auth/presentation/notifiers/auth_notifier.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Test Suite: AuthNotifier Presentation Unit Tests
/// Purpose: Validate state changes and use case interactions within AuthNotifier.
void main() {
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const LoginParams(email: 'test@company.com', password: 'Pass@123'));
  });

  setUp(() {
    locator.reset();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    locator.registerLazySingleton<GetCurrentUserUseCase>(() => mockGetCurrentUserUseCase);
    locator.registerLazySingleton<LoginUseCase>(() => mockLoginUseCase);
    locator.registerLazySingleton<LogoutUseCase>(() => mockLogoutUseCase);
  });

  const testUser = User(
    id: 'usr_1',
    email: 'email@company.com',
    name: 'Traveler',
    token: 'token_123',
  );

  group('AuthNotifier', () {
    // Purpose: Verify initial session re-hydration when an authenticated user session is active.
    test('build() initializes with currentUser when available', () async {
      when(() => mockGetCurrentUserUseCase(any()))
          .thenAnswer((_) async => const Right(testUser));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = await container.read(authNotifierProvider.future);

      expect(user, testUser);
      verify(() => mockGetCurrentUserUseCase(any())).called(1);
    });

    // Purpose: Test successful authentication flow and state update to AsyncValue.data(user).
    test('login() updates state to User when login is successful', () async {
      when(() => mockGetCurrentUserUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(testUser));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      final success = await notifier.login('email@company.com', 'Pass@123');

      expect(success, true);
      expect(container.read(authNotifierProvider).value, testUser);
      verify(() => mockLoginUseCase(any())).called(1);
    });

    // Purpose: Test failed authentication handling and state transition to AsyncValue.error.
    test('login() returns false and updates state to error when login fails', () async {
      when(() => mockGetCurrentUserUseCase(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(Failure.unauthorized('Invalid credentials')));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      final success = await notifier.login('email@company.com', 'wrongpassword');

      expect(success, false);
      expect(container.read(authNotifierProvider).hasError, true);
      verify(() => mockLoginUseCase(any())).called(1);
    });

    // Purpose: Test logout functionality and state clearing to null.
    test('logout() clears user state to null', () async {
      when(() => mockGetCurrentUserUseCase(any()))
          .thenAnswer((_) async => const Right(testUser));
      when(() => mockLogoutUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.logout();

      expect(container.read(authNotifierProvider).value, null);
      verify(() => mockLogoutUseCase(any())).called(1);
    });
  });
}
