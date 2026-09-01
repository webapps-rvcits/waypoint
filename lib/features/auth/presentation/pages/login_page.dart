import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme.dart';
import '../notifiers/auth_notifier.dart';

final loginObscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);
final loginIsLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Presentation Page: LoginPage
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'email@company.com');
  final _passwordController = TextEditingController(text: 'Pass@123');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(loginIsLoadingProvider.notifier).state = true;
    final success = await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    ref.read(loginIsLoadingProvider.notifier).state = false;
    if (!success && mounted) {
      final authState = ref.read(authNotifierProvider);
      final errorMessage = authState.whenOrNull(
            error: (err, _) => err.toString(),
          ) ??
          'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(loginObscurePasswordProvider);
    final isLoading = ref.watch(loginIsLoadingProvider);

    return Scaffold(
      backgroundColor: AppTheme.inkSurface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1C3330), Color(0xFF101C1B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Welcome back',
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.inkDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to log your trip spend',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppTheme.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    key: const Key('login_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'email@company.com',
                      labelText: 'Email',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(val.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('login_password_field'),
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppTheme.inkMuted,
                        ),
                        onPressed: () {
                          ref.read(loginObscurePasswordProvider.notifier).state =
                              !obscurePassword;
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (!val.contains(RegExp(r'[A-Z]'))) {
                        return 'Must contain at least 1 uppercase letter';
                      }
                      if (!val.contains(RegExp(r'[a-z]'))) {
                        return 'Must contain at least 1 lowercase letter';
                      }
                      if (!val.contains(RegExp(r'[0-9]'))) {
                        return 'Must contain at least 1 number';
                      }
                      final specialCharRegex = RegExp(r'[\$#@_&!\*\^\-\+~]');
                      if (!val.contains(specialCharRegex)) {
                        return 'Must contain at least 1 special char (\$,#,?,@,_,&,!,*,^,-,+,~)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    key: const Key('login_submit_button'),
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          color: AppTheme.accentMoney,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
