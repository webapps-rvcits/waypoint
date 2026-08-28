import 'package:flutter_test/flutter_test.dart';
import 'package:travelexpense/features/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  late MockAuthRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockAuthRemoteDataSource();
  });

  group('MockAuthRemoteDataSource', () {
    test('login returns UserModel for valid credentials', () async {
      final userModel = await dataSource.login('user@company.com', 'password123');

      expect(userModel.email, 'user@company.com');
      expect(userModel.name, 'User');
      expect(userModel.token, isNotNull);
    });

    test('login throws Exception when email contains "error"', () async {
      expect(
        () => dataSource.login('error@company.com', 'password123'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
