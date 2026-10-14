import 'package:flutter/material.dart';

/// Standard named route definitions for Cardify.
class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/';
  static const String dashboard = '/dashboard';
  static const String notifications = '/notifications';
  static const String cardGroups = '/card-groups';
  static const String addCardGroup = '/add-card-group';
  static const String editCardGroup = '/edit-card-group';
  static const String cardGroupDetail = '/card-group-detail';
  static const String addCard = '/add-card';
  static const String academicSchedule = '/academic-schedule';
  static const String editAcademicSchedule = '/edit-academic-schedule';
  static const String profile = '/profile';

  /// Smoothly navigates back to the Dashboard by popping back with the natural reverse
  /// slide-out transition if Dashboard exists on the route stack, or pushing Dashboard if not.
  static void returnToDashboard(BuildContext context, {VoidCallback? onBackToHome}) {
    if (onBackToHome != null) {
      onBackToHome();
      return;
    }
    bool hasDashboard = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == AppRoutes.dashboard) {
        hasDashboard = true;
        return true;
      }
      return route.isFirst;
    });
    if (!hasDashboard) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }
}
