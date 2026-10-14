import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/academic_schedule/presentation/screens/academic_schedule_screen.dart';
import 'features/academic_schedule/presentation/screens/edit_academic_schedule_screen.dart';
import 'features/card_management/presentation/screens/add_card_form_screen.dart';
import 'features/card_management/presentation/screens/add_card_group_screen.dart';
import 'features/card_management/presentation/screens/card_group_detail_screen.dart';
import 'features/card_management/presentation/screens/card_groups_overview_screen.dart';
import 'features/card_management/presentation/screens/edit_card_group_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/dashboard/presentation/screens/notification_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_flow_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CardifyApp());
}

class CardifyApp extends StatelessWidget {
  final String initialRoute;

  const CardifyApp({
    super.key,
    this.initialRoute = AppRoutes.onboarding,
  });

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case AppRoutes.onboarding:
        page = Builder(
          builder: (context) => OnboardingFlowScreen(
            onAuthenticated: () {
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            },
          ),
        );
        break;
      case AppRoutes.dashboard:
        page = Builder(
          builder: (context) => DashboardScreen(
            onOpenNotifications: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
        );
        break;
      case AppRoutes.notifications:
        page = Builder(
          builder: (context) => NotificationScreen(
            onBack: () {
              Navigator.pop(context);
            },
          ),
        );
        break;
      case AppRoutes.cardGroups:
        page = const CardGroupsOverviewScreen();
        break;
      case AppRoutes.addCardGroup:
        page = const AddCardGroupScreen();
        break;
      case AppRoutes.editCardGroup:
        page = const EditCardGroupScreen();
        break;
      case AppRoutes.cardGroupDetail:
        page = const CardGroupDetailScreen();
        break;
      case AppRoutes.addCard:
        page = const AddCardFormScreen();
        break;
      case AppRoutes.academicSchedule:
        page = const AcademicScheduleScreen();
        break;
      case AppRoutes.editAcademicSchedule:
        page = const EditAcademicScheduleScreen();
        break;
      case AppRoutes.profile:
        page = const ProfileScreen();
        break;
      default:
        page = Builder(
          builder: (context) => DashboardScreen(
            onOpenNotifications: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
        );
    }

    return SlidePageRouteBuilder(
      child: page,
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

/// Custom PageRouteBuilder delivering smooth right-to-left slide transitions
/// for forward navigation, and fluid reverse slide-out transitions when returning.
class SlidePageRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlidePageRouteBuilder({
    required this.child,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
          },
        );
}
