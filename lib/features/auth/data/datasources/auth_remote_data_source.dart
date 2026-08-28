import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('error') || password == 'wrongpassword') {
      throw Exception('Invalid credentials provided. Check your email and password.');
    }

    final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    final name = email.split('@').first;
    final formattedName = name.isEmpty
        ? 'Traveler'
        : name[0].toUpperCase() + name.substring(1);

    return UserModel(
      id: 'usr_${email.hashCode}',
      email: email,
      name: formattedName,
      token: token,
    );
  }
}
