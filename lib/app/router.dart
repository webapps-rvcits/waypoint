import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/notifiers/auth_notifier.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/expenses/domain/entities/expense.dart';
import '../features/expenses/presentation/pages/expense_detail_page.dart';
import '../features/expenses/presentation/pages/expense_form_page.dart';
import '../features/expenses/presentation/pages/expense_list_page.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final isLoggedIn = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ExpenseListPage(),
        routes: [
          GoRoute(
            path: 'expense/new',
            builder: (context, state) => const ExpenseFormPage(),
          ),
          GoRoute(
            path: 'expense/edit',
            builder: (context, state) => ExpenseFormPage(
              expenseToEdit: state.extra as Expense?,
            ),
          ),
          GoRoute(
            path: 'expense/detail',
            builder: (context, state) => ExpenseDetailPage(
              expense: state.extra as Expense,
            ),
          ),
        ],
      ),
    ],
  );
}
