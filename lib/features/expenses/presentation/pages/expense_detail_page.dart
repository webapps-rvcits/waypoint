import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';

/// Presentation Page: ExpenseDetailPage
/// 
/// TEST SPECIFICATION & DOCUMENTATION:
/// - Test Target: test/features/expenses/presentation/pages/expense_pages_test.dart
/// - Purpose of Test: Validate read-only expense detail view rendering.
/// - Objective of Test: Ensure title, formatted currency amount, category badge, formatted date, note field, and edit icon trigger correctly.
class ExpenseDetailPage extends ConsumerWidget {
  final Expense expense;

  const ExpenseDetailPage({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(expense.date);
    final currencySymbol = expense.currency == 'USD' ? '\$' : '${expense.currency} ';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.push('/expense/edit', extra: expense);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF6F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$currencySymbol${expense.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 36,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    expense.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            _buildDetailRow(context, 'Category', expense.category),
            const Divider(height: 32),
            _buildDetailRow(context, 'Date', formattedDate),
            const Divider(height: 32),
            _buildDetailRow(context, 'Currency', expense.currency),
            if (expense.note != null && expense.note!.isNotEmpty) ...[
              const Divider(height: 32),
              _buildDetailRow(context, 'Note', expense.note!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
