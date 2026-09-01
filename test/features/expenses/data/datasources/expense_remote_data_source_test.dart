import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:travelexpense/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:travelexpense/features/expenses/data/models/expense_model.dart';

void main() {
  group('HttpExpenseRemoteDataSource', () {
    test('fetchExpenses sends GET /expenses and returns list of ExpenseModel on 200 OK', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/expenses');
        return http.Response(
          jsonEncode([
            {
              'id': 'exp_1',
              'amount': 86.4,
              'currency': 'USD',
              'title': 'Client dinner',
              'category': 'Meals',
              'date': '2026-09-02T00:00:00.000Z',
            }
          ]),
          200,
        );
      });

      final dataSource = HttpExpenseRemoteDataSource(client: mockClient);
      final result = await dataSource.fetchExpenses();

      expect(result.length, 1);
      expect(result.first.title, 'Client dinner');
    });

    test('addExpense sends POST /expense and returns ExpenseModel on 201 Created', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/expense');
        return http.Response(
          jsonEncode({
            'id': 'exp_999',
            'amount': 25.0,
            'currency': 'USD',
            'title': 'Taxi',
            'category': 'Transit',
            'date': '2026-09-02T00:00:00.000Z',
          }),
          201,
        );
      });

      final dataSource = HttpExpenseRemoteDataSource(client: mockClient);
      const input = ExpenseModel(
        id: '',
        amount: 25.0,
        currency: 'USD',
        title: 'Taxi',
        category: 'Transit',
        date: '2026-09-02T00:00:00.000Z',
      );

      final result = await dataSource.addExpense(input);
      expect(result.id, 'exp_999');
      expect(result.title, 'Taxi');
    });

    test('updateExpense sends PUT /expense/:id and returns updated ExpenseModel on 200 OK', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/api/v1/expense/exp_1');
        return http.Response(
          jsonEncode({
            'id': 'exp_1',
            'amount': 99.0,
            'currency': 'USD',
            'title': 'Updated Client dinner',
            'category': 'Meals',
            'date': '2026-09-02T00:00:00.000Z',
          }),
          200,
        );
      });

      final dataSource = HttpExpenseRemoteDataSource(client: mockClient);
      const input = ExpenseModel(
        id: 'exp_1',
        amount: 99.0,
        currency: 'USD',
        title: 'Updated Client dinner',
        category: 'Meals',
        date: '2026-09-02T00:00:00.000Z',
      );

      final result = await dataSource.updateExpense(input);
      expect(result.id, 'exp_1');
      expect(result.title, 'Updated Client dinner');
      expect(result.amount, 99.0);
    });

    test('deleteExpense sends DELETE /expense/:id and completes on 200 OK', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/v1/expense/exp_1');
        return http.Response('', 200);
      });

      final dataSource = HttpExpenseRemoteDataSource(client: mockClient);
      await expectLater(dataSource.deleteExpense('exp_1'), completes);
    });
  });
}
