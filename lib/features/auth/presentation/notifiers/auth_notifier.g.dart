// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'64e95172502f774955c29a6dc6c7a04e9338288a';

/// Presentation Notifier: AuthNotifier
///
/// TEST SPECIFICATION & DOCUMENTATION:
/// - Test Target: test/features/auth/presentation/notifiers/auth_notifier_test.dart
/// - Purpose of Tests: Validate state management and business logic orchestration for User authentication.
/// - Objectives:
///   1. build(): Verify initial user session re-hydration from GetCurrentUserUseCase.
///   2. login(email, password): Verify state transition to loading and then to user data on success, or error state on invalid credentials.
///   3. logout(): Verify token invalidation and clearing user state to null.
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, User?>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
