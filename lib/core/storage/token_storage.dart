import 'package:hive_flutter/hive_flutter.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class HiveTokenStorage implements TokenStorage {
  static const _boxName = 'auth_box';
  static const _key = 'auth_token';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> saveToken(String token) async {
    final box = await _getBox();
    await box.put(_key, token);
  }

  @override
  Future<String?> getToken() async {
    final box = await _getBox();
    return box.get(_key) as String?;
  }

  @override
  Future<void> deleteToken() async {
    final box = await _getBox();
    await box.delete(_key);
  }
}
