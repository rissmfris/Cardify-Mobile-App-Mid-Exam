import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../models/language_option.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'language_screen.dart';
import 'educational_card_group_screen.dart';
import 'how_to_card_group_screen.dart';
import 'how_to_card_screen.dart';
import 'auth_gateway_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

/// Master Onboarding Flow controller using PageView.
/// Handles smooth transitions across all 8 screens and optional splash screen.
class OnboardingFlowScreen extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  const OnboardingFlowScreen({
    super.key,
    this.onAuthenticated,
  });

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showingSplashModal = false;
  AppLanguage _selectedLanguage = AppLanguage.indonesian;
  bool _showJumpMenu = false;

  final List<String> _screenTitles = [
    '1. Welcome',
    '2. Language',
    '3. What is Card?',
    '4. How Card Group?',
    '5. How Card?',
    '6. Auth Gateway',
    '7. Sign In',
    '8. Sign Up',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToAuth() {
    _navigateToPage(5); // Jump directly to Screen 6 (Auth Gateway)
  }

  @override
  Widget build(BuildContext context) {
    if (_showingSplashModal) {
      return SplashScreen(
        onDismiss: () {
          setState(() {
            _showingSplashModal = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Main PageView with all 8 screens
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // SCREEN 1: Welcome Screen
              WelcomeScreen(
                onGetStarted: () => _navigateToPage(1),
                onSkip: _skipToAuth,
                onPreviewSplash: () {
                  setState(() {
                    _showingSplashModal = true;
                  });
                },
              ),

              // SCREEN 2: Select Language
              LanguageScreen(
                initialLanguage: _selectedLanguage,
                onLanguageChanged: (lang) {
                  setState(() {
                    _selectedLanguage = lang;
                  });
                },
                onBack: () => _navigateToPage(0),
                onNext: () => _navigateToPage(2),
              ),

              // SCREEN 3: Educational Flow 1 ("What is Card & Group?")
              EducationalCardGroupScreen(
                onBack: () => _navigateToPage(1),
                onNext: () => _navigateToPage(3),
                onSkip: _skipToAuth,
              ),

              // SCREEN 4: Educational Flow 2 ("How to Card Group?")
              HowToCardGroupScreen(
                onBack: () => _navigateToPage(2),
                onNext: () => _navigateToPage(4),
                onSkip: _skipToAuth,
              ),

              // SCREEN 5: Educational Flow 3 ("How to Card")
              HowToCardScreen(
                onBack: () => _navigateToPage(3),
                onNext: () => _navigateToPage(5),
                onSkip: _skipToAuth,
              ),

              // SCREEN 6: Auth Gateway (Welcome Options)
              AuthGatewayScreen(
                onSignIn: () => _navigateToPage(6),
                onSignUp: () => _navigateToPage(7),
                onBack: () => _navigateToPage(4),
              ),

              // SCREEN 7: Sign In Screen
              SignInScreen(
                onBack: () => _navigateToPage(5),
                onNavigateToSignUp: () => _navigateToPage(7),
                onSignIn: (username, password) {
                  if (widget.onAuthenticated != null) {
                    widget.onAuthenticated!();
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                  }
                },
              ),

              // SCREEN 8: Sign Up Screen
              SignUpScreen(
                onBack: () => _navigateToPage(5),
                onNavigateToSignIn: () => _navigateToPage(6),
                onSignUp: (name, email, password) {
                  if (widget.onAuthenticated != null) {
                    widget.onAuthenticated!();
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                  }
                },
              ),
            ],
          ),

          // Floating Screen Switcher Pill (Helper for seamless testing & presentation)
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Center(
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showJumpMenu = !_showJumpMenu;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xD919191B),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Step ${_currentPage + 1}/8: ${_screenTitles[_currentPage]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _showJumpMenu
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.tune_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Screen Jump Drawer / Overlay
          if (_showJumpMenu)
            Positioned(
              bottom: 48,
              left: 20,
              right: 20,
              child: SafeArea(
                top: false,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jump directly to Screen',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                setState(() {
                                  _showJumpMenu = false;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildJumpChip('Splash (Logo)', -1),
                            ...List.generate(8, (i) {
                              return _buildJumpChip(_screenTitles[i], i);
                            }),
                            if (widget.onAuthenticated != null)
                              _buildJumpChip('Dashboard ->', -2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJumpChip(String title, int targetIndex) {
    final bool isSelected = targetIndex == _currentPage;
    return GestureDetector(
      onTap: () {
        setState(() {
          _showJumpMenu = false;
        });
        if (targetIndex == -1) {
          setState(() {
            _showingSplashModal = true;
          });
        } else if (targetIndex == -2) {
          if (widget.onAuthenticated != null) {
            widget.onAuthenticated!();
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
        } else {
          _navigateToPage(targetIndex);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlack : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
