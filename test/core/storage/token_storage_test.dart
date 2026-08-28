import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelexpense/core/storage/token_storage.dart';

void main() {
  late SharedPrefTokenStorage tokenStorage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    tokenStorage = SharedPrefTokenStorage();
  });

  group('SharedPrefTokenStorage', () {
    test('getToken returns null when no token is saved', () async {
      final token = await tokenStorage.getToken();
      expect(token, isNull);
    });

    test('saveToken saves token and getToken retrieves it', () async {
      await tokenStorage.saveToken('jwt_123');
      final token = await tokenStorage.getToken();
      expect(token, 'jwt_123');
    });

    test('deleteToken removes saved token', () async {
      await tokenStorage.saveToken('jwt_123');
      await tokenStorage.deleteToken();
      final token = await tokenStorage.getToken();
      expect(token, isNull);
    });
  });
}
