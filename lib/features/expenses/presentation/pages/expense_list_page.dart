import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../notifiers/expense_list_notifier.dart';
import '../widgets/expense_card.dart';

/// Presentation Page: ExpenseListPage
///
/// TEST SPECIFICATION & DOCUMENTATION:
/// - Test Target: test/features/expenses/presentation/pages/expense_pages_test.dart
/// - Purpose of Test: Validate full list rendering, total spent calculation header, category filtering, and pull-to-refresh.
/// - Objective of Test: Verify that the ledger-strip header displays the aggregated dollar amount, filter chips filter the expense cards by category, and clicking FAB opens ExpenseFormPage.
class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListNotifierProvider);
    final selectedFilter = ref.watch(selectedCategoryFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.inkSurface,
      appBar: AppBar(
        title: Text(
          'Waypoint',
          style: GoogleFonts.libreBaskerville(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            key: const Key('logout_button'),
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign out',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                ref.read(authNotifierProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_expense_fab'),
        backgroundColor: AppTheme.accentMoney,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          context.push('/expense/new');
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(expenseListNotifierProvider.notifier).refresh(),
          child: expensesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.accentMoney),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error loading expenses',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(expenseListNotifierProvider.notifier)
                          .refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (expenses) {
              final filteredExpenses = selectedFilter == 'All'
                  ? expenses
                  : expenses
                        .where((e) => e.category == selectedFilter)
                        .toList();

              final totalSpent = expenses.fold<double>(
                0.0,
                (sum, item) => sum + item.amount,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Spent Header Banner (Sample Design matching ledger strip)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This trip',
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.inkDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TOTAL SPENT',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.inkMuted,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${totalSpent.toStringAsFixed(2)}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.accentMoney,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: ['All', 'Meals', 'Transit', 'Lodging', 'Other']
                          .map((category) {
                            final isSelected = selectedFilter == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (_) {
                                  ref
                                      .read(
                                        selectedCategoryFilterProvider.notifier,
                                      )
                                      .select(category);
                                },
                                selectedColor: AppTheme.accentMoney,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.inkDark,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppTheme.accentMoney
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Expenses list or Empty state
                  Expanded(
                    child: filteredExpenses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No expenses found',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppTheme.inkMuted),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            itemCount: filteredExpenses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final expense = filteredExpenses[index];
                              return ExpenseCard(
                                expense: expense,
                                onDelete: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Expense'),
                                      content: Text(
                                        'Are you sure you want to delete "${expense.title}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    await ref
                                        .read(
                                          expenseListNotifierProvider.notifier,
                                        )
                                        .deleteExpense(expense.id);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
