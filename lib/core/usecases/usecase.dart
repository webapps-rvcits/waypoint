import 'package:fpdart/fpdart.dart';
import '../error/failure.dart';

/// Reso Coder's UseCase contract:
/// `abstract class UseCase<Type, Params>`
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
