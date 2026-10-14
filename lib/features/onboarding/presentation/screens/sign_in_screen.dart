import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/onboarding_header_bar.dart';

/// SCREEN 7 - Sign In Screen
/// Derived from PDF Page 8:
/// - Back action: "< Sign In"
/// - Input fields: "Username/email" and "Password"
/// - Helper link: "Forgot Password?"
/// - Primary action: "Sign In" button
/// - Footer link: "Didn't have any account? Sign Up"
/// - Social login: "Or Sign In With" + Google button ("G Google")
class SignInScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNavigateToSignUp;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleSignIn;
  final Function(String username, String password)? onSignIn;

  const SignInScreen({
    super.key,
    required this.onBack,
    required this.onNavigateToSignUp,
    this.onForgotPassword,
    this.onGoogleSignIn,
    this.onSignIn,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your username/email'),
          backgroundColor: AppColors.urgentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your password'),
          backgroundColor: AppColors.urgentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (widget.onSignIn != null) {
      widget.onSignIn!(username, password);
    } else {
      // Seamlessly navigate to the Dashboard using pushReplacement to prevent back-looping
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
              // Top Back Navigation "< Sign In"
              OnboardingHeaderBar(
                showBack: true,
                backTitle: 'Sign In',
                onBack: widget.onBack,
              ),

              const SizedBox(height: 32),

              // Username/email Input
              CustomTextField(
                label: 'Username/email',
                hintText: 'Insert Username/email',
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Password Input
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

              const SizedBox(height: 12),

              // Helper link: "Forgot Password?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onForgotPassword ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Password recovery email requested'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.primaryBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.linkText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Primary action: "Sign In"
              CustomPrimaryButton(
                text: 'Sign In',
                onPressed: _handleSignIn,
              ),

              const SizedBox(height: 16),

              // Secondary action button: "Didn't have any account? Sign Up"
              SizedBox(
                height: 54,
                width: double.infinity,
                child: TextButton(
                  onPressed: widget.onNavigateToSignUp,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't have any account? ",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Sign Up',
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

              const SizedBox(height: 36),

              // Social divider: "Or Sign In With"
              Center(
                child: Text(
                  'Or Sign In With',
                  style: AppTypography.bodyMuted.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Google SSO Button
              GoogleAuthButton(
                onPressed: widget.onGoogleSignIn ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Google Sign In initiated'),
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
