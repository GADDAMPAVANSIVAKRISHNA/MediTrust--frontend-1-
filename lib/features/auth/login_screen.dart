import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // By default, login as Patient. Onboarding role selection will determine actual role.
        // We will default to Patient for simple login, or redirect to role-selection.
        // Let's do: if they log in via email, we will set them to Patient or let them choose.
        // Actually, let's log them in. Since they are logging in, if their role is guest,
        // GoRouter will redirect them to '/role-selection' which matches the auth_provider logic!
        await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
          UserRole.guest, // Login as guest to force role selection or restore previous role
        );
        if (mounted) {
          context.go('/role-selection');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimaryLight, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Custom Tab Switcher (Login/Sign Up Toggle)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/signup'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Form Inputs
                CustomTextField(
                  label: 'Email or Phone Number',
                  hint: 'Enter your email or phone',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email/phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  isPassword: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Submit Button
                CustomButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 32),
                
                // Continue with divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.borderLight)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.borderLight)),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Social Logins Cards Row
                Row(
                  children: [
                    Expanded(child: _socialCard('Google', Icons.g_mobiledata)),
                    const SizedBox(width: 12),
                    Expanded(child: _socialCard('Apple', Icons.apple)),
                    const SizedBox(width: 12),
                    Expanded(child: _socialCard('Facebook', Icons.facebook)),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textSecondaryLight),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialCard(String name, IconData icon) {
    return InkWell(
      onTap: () {
        // Quick login for testing
        _emailController.text = '${name.toLowerCase()}@meditrust.com';
        _passwordController.text = 'password123';
        _submit();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimaryLight, size: 22),
            const SizedBox(width: 6),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
