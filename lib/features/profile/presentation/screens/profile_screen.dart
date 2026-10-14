import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/smooth_switch_toggle.dart';
import '../../../dashboard/presentation/widgets/add_cards_popover.dart';
import '../../../dashboard/presentation/widgets/bottom_dock_nav_bar.dart';
import '../widgets/choose_language_modal.dart';
import '../widgets/logout_confirmation_dialog.dart';
import '../widgets/profile_avatar_header.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_picture_modal.dart';
import '../widgets/profile_section_card.dart';

/// SCREEN 1 - Profile Screen (Root-level Tab)
/// Derived from Updated Profile PDF document:
/// - Navigation Role: Primary root-level tab/view (equivalent to Dashboard & Schedule)
/// - NO back button ('<') on this main profile view
/// - Profile Header & Avatar with edit/pencil badge overlay
/// - Account Section: rezky4478@gmail.com & Log Out (with confirmation dialog)
/// - Preference Section: Language (with Choose Language modal) & Themes
/// - Settings Section: Notification
/// - Bottom Dock Navigation Bar with Profile tab active
class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ProfileScreen({
    super.key,
    this.onBackToHome,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _handleBackToDashboard() {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  void _showProfilePictureModal() {
    ProfilePictureModal.show(
      context,
      onGallerySelected: () {
        AppSnackBar.show(
          context,
          message: 'Profile picture updated from Gallery.',
          icon: Icons.photo_library_outlined,
        );
      },
      onCameraSelected: () {
        AppSnackBar.show(
          context,
          message: 'Profile picture captured from Camera.',
          icon: Icons.camera_alt_outlined,
        );
      },
    );
  }

  void _showLogoutDialog() {
    LogoutConfirmationDialog.show(
      context,
      onConfirmLogout: () {
        // Clear back stack and return to Onboarding / Login
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onboarding,
          (route) => false,
        );
      },
    );
  }

  void _showLanguageModal() {
    ChooseLanguageModal.show(
      context,
      onLanguageSelected: (lang) {
        AppSnackBar.show(
          context,
          message: 'Language changed to $lang.',
          icon: Icons.translate_rounded,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackToDashboard();
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Header Bar: "Profile" Title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Profile',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable Profile Sections
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 96.0),
                          children: [
                            // 1. Profile Avatar Header
                            ProfileAvatarHeader(
                              onTapEdit: _showProfilePictureModal,
                            ),

                            const SizedBox(height: 24),

                            // 2. Account Section
                            ProfileSectionCard(
                              title: 'Account',
                              children: [
                                ProfileMenuTile(
                                  title: 'rezky4478@gmail.com',
                                  trailingIcon: Icons.swap_horiz_rounded,
                                  onTap: () {
                                    AppSnackBar.show(
                                      context,
                                      message: 'Account: rezky4478@gmail.com',
                                      icon: Icons.account_circle_outlined,
                                    );
                                  },
                                ),
                                ProfileMenuTile(
                                  title: 'Log Out',
                                  subtitle: 'Log Out from this account',
                                  trailingIcon: Icons.logout_rounded,
                                  isDestructive: true,
                                  showDivider: false,
                                  onTap: _showLogoutDialog,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // 3. Preference Section
                            ProfileSectionCard(
                              title: 'Preference',
                              children: [
                                ProfileMenuTile(
                                  title: 'Language',
                                  subtitle: 'English (US) / Bahasa Indonesia',
                                  trailingIcon: Icons.translate_rounded,
                                  onTap: _showLanguageModal,
                                ),
                                ProfileMenuTile(
                                  title: 'Themes',
                                  subtitle: 'Light & Dark theme appearance',
                                  trailingIcon: Icons.palette_outlined,
                                  showDivider: false,
                                  onTap: () {
                                    AppSnackBar.show(
                                      context,
                                      message: 'Themes preference clicked.',
                                      icon: Icons.palette_outlined,
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // 4. Settings Section
                            ProfileSectionCard(
                              title: 'Settings',
                              children: [
                                ProfileMenuTile(
                                  title: 'Notification',
                                  subtitle: 'Push notifications & reminder alerts',
                                  trailing: SmoothSwitchToggle(
                                    value: _notificationsEnabled,
                                    onChanged: (val) {
                                      setState(() {
                                        _notificationsEnabled = val;
                                      });
                                      AppSnackBar.show(
                                        context,
                                        message: val
                                            ? 'Notifications activated.'
                                            : 'Notifications deactivated.',
                                        icon: val
                                            ? Icons.notifications_active_rounded
                                            : Icons.notifications_off_outlined,
                                        duration: const Duration(seconds: 2),
                                      );
                                    },
                                  ),
                                  showDivider: false,
                                  onTap: () {
                                    final val = !_notificationsEnabled;
                                    setState(() {
                                      _notificationsEnabled = val;
                                    });
                                    AppSnackBar.show(
                                      context,
                                      message: val
                                          ? 'Notifications activated.'
                                          : 'Notifications deactivated.',
                                      icon: val
                                          ? Icons.notifications_active_rounded
                                          : Icons.notifications_off_outlined,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Dock Navigation Bar (active tab index 3 for Profile)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomDockNavBar(
                    selectedIndex: 3,
                    onItemSelected: (index) {
                      if (index == 0) {
                        AppRoutes.returnToDashboard(context);
                      } else if (index == 1) {
                        Navigator.pushReplacementNamed(context, AppRoutes.cardGroups);
                      } else if (index == 2) {
                        Navigator.pushReplacementNamed(context, AppRoutes.academicSchedule);
                      }
                    },
                    onAddPressed: () => AddCardsPopover.show(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
