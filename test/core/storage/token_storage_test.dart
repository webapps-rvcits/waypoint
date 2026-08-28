import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travelexpense/core/storage/token_storage.dart';

void main() {
  late HiveTokenStorage tokenStorage;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    tokenStorage = HiveTokenStorage();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveTokenStorage', () {
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
