import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/onboarding_header_bar.dart';

/// SCREEN 8 - Sign Up Screen
/// Derived from PDF Page 9:
/// - Back action: "< Sign Up"
/// - Input fields: "Name", "Email", "Password", "Confirm Password"
/// - Primary action: "Sign Up" button
/// - Social SSO option: "Or Sign Up With" + Google button ("G Google")
class SignUpScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNavigateToSignIn;
  final VoidCallback? onGoogleSignUp;
  final Function(String name, String email, String password)? onSignUp;

  const SignUpScreen({
    super.key,
    required this.onBack,
    required this.onNavigateToSignIn,
    this.onGoogleSignUp,
    this.onSignUp,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: AppColors.urgentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match'),
          backgroundColor: AppColors.urgentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (widget.onSignUp != null) {
      widget.onSignUp!(
        name,
        email,
        password,
      );
    } else {
      // Seamlessly navigate to Dashboard using pushReplacement to prevent back-looping
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Navigation "< Sign Up"
              OnboardingHeaderBar(
                showBack: true,
                backTitle: 'Sign Up',
                onBack: widget.onBack,
              ),

              const SizedBox(height: 24),

              // 1. Name Input
              CustomTextField(
                label: 'Name',
                hintText: 'Insert Your Name',
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 18),

              // 2. Email Input
              CustomTextField(
                label: 'Email',
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // 3. Password Input
              CustomTextField(
                label: 'Password',
                hintText: 'Insert Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 18),

              // 4. Confirm Password Input
              CustomTextField(
                label: 'Confirm Password',
                hintText: 'Insert Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Primary action: "Sign Up" button
              CustomPrimaryButton(
                text: 'Sign Up',
                onPressed: _handleSignUp,
              ),

              const SizedBox(height: 16),

              // "Already have an account? Sign In" link
              Center(
                child: TextButton(
                  onPressed: widget.onNavigateToSignIn,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Social divider: "Or Sign Up With"
              Center(
                child: Text(
                  'Or Sign Up With',
                  style: AppTypography.bodyMuted.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Google SSO Button
              GoogleAuthButton(
                onPressed: widget.onGoogleSignUp ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Google Sign Up initiated'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primaryBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
