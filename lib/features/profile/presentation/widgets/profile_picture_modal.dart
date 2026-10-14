import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Modal dialog for "Changes your Profile Picture".
/// Derived from Screen 3 in the design PDF.
class ProfilePictureModal extends StatelessWidget {
  final VoidCallback onGallerySelected;
  final VoidCallback onCameraSelected;

  const ProfilePictureModal({
    super.key,
    required this.onGallerySelected,
    required this.onCameraSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGallerySelected,
    required VoidCallback onCameraSelected,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => ProfilePictureModal(
        onGallerySelected: () {
          Navigator.pop(context);
          onGallerySelected();
        },
        onCameraSelected: () {
          Navigator.pop(context);
          onCameraSelected();
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
            // Header Title: "Changes your Profile Picture"
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Changes your Profile Picture',
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

            // Option 1: Gallery
            InkWell(
              onTap: onGallerySelected,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 22,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F0F2),
            ),

            // Option 2: Camera
            InkWell(
              onTap: onCameraSelected,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 22,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
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
