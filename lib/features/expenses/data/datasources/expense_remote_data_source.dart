import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> fetchExpenses();
  Future<ExpenseModel> addExpense(ExpenseModel model);
  Future<ExpenseModel> updateExpense(ExpenseModel model);
  Future<void> deleteExpense(String id);
}

class HttpExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  HttpExpenseRemoteDataSource({
    this.baseUrl = 'https://edf-api-laravel-staging.onrender.com/api/v1',
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  Future<List<ExpenseModel>> fetchExpenses() async {
    final response = await client.get(
      Uri.parse('$baseUrl/expenses'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> jsonList = decoded is List
          ? decoded
          : (decoded['data'] ?? []);
      return jsonList
          .map(
            (e) => ExpenseModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load expenses from server: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel model) async {
    final response = await client.post(
      Uri.parse('$baseUrl/expense'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded is Map<String, dynamic>
          ? (decoded['data'] is Map<String, dynamic> ? decoded['data'] : decoded)
          : {};
      return ExpenseModel.fromJson(
        data.containsKey('id') ? data : model.toJson(),
      );
    } else {
      throw Exception('Failed to add expense: ${response.statusCode}');
    }
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel model) async {
    final response = await client.put(
      Uri.parse('$baseUrl/expense/${model.id}'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded is Map<String, dynamic>
          ? (decoded['data'] is Map<String, dynamic> ? decoded['data'] : decoded)
          : {};
      return ExpenseModel.fromJson(
        data.containsKey('id') ? data : model.toJson(),
      );
    } else {
      throw Exception('Failed to update expense: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/expense/$id'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete expense: ${response.statusCode}');
    }
  }
}
