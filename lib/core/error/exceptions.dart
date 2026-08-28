import 'package:freezed_annotation/freezed_annotation.dart';

part 'exceptions.freezed.dart';

@freezed
class ServerException with _$ServerException implements Exception {
  const factory ServerException([String? message]) = _ServerException;
}

@freezed
class CacheException with _$CacheException implements Exception {
  const factory CacheException([String? message]) = _CacheException;
}

@freezed
class NetworkException with _$NetworkException implements Exception {
  const factory NetworkException([String? message]) = _NetworkException;
}

@freezed
class AuthenticationException with _$AuthenticationException implements Exception {
  const factory AuthenticationException([String? message]) = _AuthenticationException;
}
