import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

/// SCREEN 3 - Add Cards Action / Bottom Sheet Popover Menu
/// Derived from PDF Page 4:
/// - Floating white card with centered downward pointer towards '+' dock button
/// - Header: "Add Cards"
/// - Options: "Academic Card", "Organization Card", "Community Card", "Add Other Card Group"
class AddCardsPopover extends StatelessWidget {
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onDismiss;

  const AddCardsPopover({
    super.key,
    required this.onOptionSelected,
    required this.onDismiss,
  });

  /// Unified global display function for the '+' dock button across all tabs.
  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Cards',
      barrierColor: const Color(0x66000000), // smooth dark scrim backdrop
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, anim1, anim2) {
        return AddCardsPopover(
          onOptionSelected: (option) {
            Navigator.pop(dialogContext);
            if (option == 'Add Other Card Group') {
              Navigator.pushNamed(context, AppRoutes.addCardGroup);
            } else {
              Navigator.pushNamed(
                context,
                AppRoutes.addCard,
                arguments: option,
              );
            }
          },
          onDismiss: () => Navigator.pop(dialogContext),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInOutCubic,
        );
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.72, end: 1.0).animate(scaleAnimation),
            alignment: const Alignment(0.0, 0.86), // anchored directly at the bottom '+' button
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Popover Card with downward pointer positioned above bottom dock
            Positioned(
              bottom: 84.0, // Above dock bar
              left: 24.0,
              right: 24.0,
              child: GestureDetector(
                onTap: () {}, // Prevent dismissal when tapping inside card
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main White Rounded Box
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x2B000000),
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header: "Add Cards"
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              'Add Cards',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _buildDivider(),

                          // 1. "Academic Card"
                          _buildOption(context, 'Academic Card'),
                          _buildDivider(),

                          // 2. "Organization Card"
                          _buildOption(context, 'Organization Card'),
                          _buildDivider(),

                          // 3. "Community Card"
                          _buildOption(context, 'Community Card'),
                          _buildDivider(),

                          // 4. "Add Other Card Group"
                          _buildOption(context, 'Add Other Card Group'),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),

                    // Pointer triangle pointing to '+' button
                    CustomPaint(
                      size: const Size(22, 12),
                      painter: _PopoverPointerPainter(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F0F2),
    );
  }

  Widget _buildOption(BuildContext context, String title) {
    return InkWell(
      onTap: () => onOptionSelected(title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PopoverPointerPainter extends CustomPainter {
  final Color color;

  const _PopoverPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
