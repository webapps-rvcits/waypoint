import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/locator.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    final getCurrentUser = locator<GetCurrentUserUseCase>();
    final result = await getCurrentUser(const NoParams());
    return result.fold((failure) => null, (user) => user);
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    final loginUseCase = locator<LoginUseCase>();
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    return result.fold(
      (failure) {
        final errorMsg = failure.maybeWhen(
          unauthorized: (msg) => msg ?? 'Invalid credentials',
          unexpected: (msg) => msg ?? 'Login failed',
          orElse: () => 'Authentication error',
        );
        state = AsyncValue.error(errorMsg, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final logoutUseCase = locator<LogoutUseCase>();
    await logoutUseCase(const NoParams());
    state = const AsyncValue.data(null);
  }
}
