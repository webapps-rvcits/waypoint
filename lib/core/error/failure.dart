import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError([String? message]) = _ServerError;
  const factory Failure.networkError([String? message]) = _NetworkError;
  const factory Failure.unauthorized([String? message]) = _Unauthorized;
  const factory Failure.notFound([String? message]) = _NotFound;
  const factory Failure.unexpected([String? message]) = _Unexpected;
}
