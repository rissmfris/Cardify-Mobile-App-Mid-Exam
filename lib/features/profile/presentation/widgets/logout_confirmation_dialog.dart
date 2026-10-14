import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Confirmation dialog for user logout.
/// Derived from Screen 2 in the design PDF.
class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmLogout;
  final VoidCallback onCancel;

  const LogoutConfirmationDialog({
    super.key,
    required this.onConfirmLogout,
    required this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmLogout,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => LogoutConfirmationDialog(
        onConfirmLogout: () {
          Navigator.pop(context);
          onConfirmLogout();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title: "Are you sure want to Log Out?"
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
              child: Text(
                'Are you sure want to Log Out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F0F2),
            ),

            // Action 1: "Yes, Log Out" (Red Text)
            InkWell(
              onTap: onConfirmLogout,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Yes, Log Out',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.urgentRed,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F0F2),
            ),

            // Action 2: "Cancel" (Black Text)
            InkWell(
              onTap: onCancel,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
