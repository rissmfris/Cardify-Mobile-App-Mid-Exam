import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final interTextTheme = GoogleFonts.interTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlack,
        onPrimary: Colors.white,
        secondary: AppColors.primaryBlack,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.textPrimary,
        error: AppColors.urgentRed,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: interTextTheme,
      primaryTextTheme: interTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPlaceholder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlack, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.urgentRed, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.urgentRed, width: 1.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryBlack,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 6,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SlideRightToLeftPageTransitionsBuilder(),
          TargetPlatform.iOS: SlideRightToLeftPageTransitionsBuilder(),
          TargetPlatform.windows: SlideRightToLeftPageTransitionsBuilder(),
          TargetPlatform.macOS: SlideRightToLeftPageTransitionsBuilder(),
          TargetPlatform.linux: SlideRightToLeftPageTransitionsBuilder(),
          TargetPlatform.fuchsia: SlideRightToLeftPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Smooth right-to-left slide transition builder for primary tabs and sub-screens.
/// Automatically handles forward slide-in (right to left) and reverse slide-back (left to right).
class SlideRightToLeftPageTransitionsBuilder extends PageTransitionsBuilder {
  const SlideRightToLeftPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;
    const reverseCurve = Curves.easeInOutCubic;

    final primarySlide = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: curve))
        .animate(animation);

    final secondarySlide =
        Tween(begin: Offset.zero, end: const Offset(-0.25, 0.0))
            .chain(CurveTween(curve: reverseCurve))
            .animate(secondaryAnimation);

    return SlideTransition(
      position: secondarySlide,
      child: SlideTransition(
        position: primarySlide,
        child: child,
      ),
    );
  }
}
