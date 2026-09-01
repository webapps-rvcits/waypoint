import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../domain/entities/expense.dart';
import '../notifiers/expense_list_notifier.dart';

final expenseFormCategoryProvider = StateProvider.autoDispose.family<String, String>((ref, initial) => initial);
final expenseFormDateProvider = StateProvider.autoDispose.family<DateTime, DateTime>((ref, initial) => initial);
final expenseFormSavingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Presentation Page: ExpenseFormPage
class ExpenseFormPage extends ConsumerStatefulWidget {
  final Expense? expenseToEdit;

  const ExpenseFormPage({
    super.key,
    this.expenseToEdit,
  });

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  final List<String> _categories = ['Meals', 'Transit', 'Lodging', 'Other'];

  @override
  void initState() {
    super.initState();
    final edit = widget.expenseToEdit;
    _titleController = TextEditingController(text: edit?.title ?? '');
    _amountController = TextEditingController(
      text: edit != null ? edit.amount.toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: edit?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      ref.read(expenseFormDateProvider(widget.expenseToEdit?.date ?? DateTime.now()).notifier).state = picked;
    }
  }

  Future<void> _saveExpense(String selectedCategory, DateTime selectedDate) async {
    if (!_formKey.currentState!.validate()) return;

    final parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount > 0')),
      );
      return;
    }

    ref.read(expenseFormSavingProvider.notifier).state = true;

    final isEdit = widget.expenseToEdit != null;
    final expense = Expense(
      id: widget.expenseToEdit?.id ?? '',
      amount: parsedAmount,
      currency: widget.expenseToEdit?.currency ?? 'USD',
      title: _titleController.text.trim(),
      category: selectedCategory,
      date: selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final notifier = ref.read(expenseListNotifierProvider.notifier);
    final success = isEdit
        ? await notifier.updateExpense(expense)
        : await notifier.addExpense(expense);

    if (!mounted) return;
    ref.read(expenseFormSavingProvider.notifier).state = false;
    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving expense')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expenseToEdit != null;
    final dateFormat = DateFormat('MMM dd, yyyy');

    final initialCategory = widget.expenseToEdit?.category ?? 'Meals';
    final initialDate = widget.expenseToEdit?.date ?? DateTime.now();

    final selectedCategory = ref.watch(expenseFormCategoryProvider(initialCategory));
    final selectedDate = ref.watch(expenseFormDateProvider(initialDate));
    final isSaving = ref.watch(expenseFormSavingProvider);

    return Scaffold(
      backgroundColor: AppTheme.inkSurface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              key: const Key('expense_save_button'),
              onPressed: isSaving ? null : () => _saveExpense(selectedCategory, selectedDate),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: AppTheme.accentMoney,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            children: [
              Text(
                isEdit ? 'Edit expense' : 'New expense',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.inkDark,
                ),
              ),
              const SizedBox(height: 28),

              // Title field
              Text(
                'TITLE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('expense_title_field'),
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Client dinner',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Amount field
              Text(
                'AMOUNT',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('expense_amount_field'),
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.inkDark,
                ),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Amount is required';
                  }
                  final num = double.tryParse(val.trim());
                  if (num == null || num <= 0) {
                    return 'Enter an amount > 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category Selector Chips
              Text(
                'CATEGORY',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(expenseFormCategoryProvider(initialCategory).notifier).state = cat;
                      }
                    },
                    selectedColor: AppTheme.accentMoneyBg,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.accentMoney
                          : AppTheme.inkDark,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.accentMoney
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Date Picker Field
              Text(
                'DATE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(selectedDate),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.inputBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateFormat.format(selectedDate),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.inkDark,
                        ),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Note field
              Text(
                'NOTE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Optional detail…',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
