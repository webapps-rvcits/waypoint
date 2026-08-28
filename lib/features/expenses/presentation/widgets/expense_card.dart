import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../domain/entities/expense.dart';

/// Presentation Widget: ExpenseCard
/// 
/// TEST SPECIFICATION & DOCUMENTATION:
/// - Test Target: test/features/expenses/presentation/widgets/expense_card_test.dart
/// - Purpose of Test: Validate individual expense list row presentation widget.
/// - Objective of Test: Ensure category icon matches category enum, date is formatted as 'MMM dd', amount uses JetBrains Mono font with '$' symbol, and onTap navigates to ExpenseDetailPage.
class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Meals':
        return Icons.restaurant;
      case 'Transit':
        return Icons.directions_car;
      case 'Lodging':
        return Icons.hotel;
      default:
        return Icons.confirmation_number;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd');

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.accentMoneyBg,
          child: Icon(
            _getCategoryIcon(expense.category),
            color: AppTheme.accentMoney,
            size: 20,
          ),
        ),
        title: Text(
          expense.title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.inkDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${dateFormat.format(expense.date)} · ${expense.category}',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.inkMuted,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.inkDark,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              IconButton(
                key: Key('delete_expense_${expense.id}'),
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red.shade400,
                tooltip: 'Delete expense',
                onPressed: onDelete,
              ),
            ],
          ],
        ),
        onTap: () {
          context.push('/expense/detail', extra: expense);
        },
      ),
    );
  }
}
