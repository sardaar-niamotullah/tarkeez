import 'package:go_router/go_router.dart';
import 'package:tarkeez/features/others/feedback/presentation/feedback_page.dart';
import 'package:tarkeez/features/main_scaffold.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/features/others/hire_us/presentation/hire_us_page.dart';
import 'package:tarkeez/features/subscription/presentation/subscription_page.dart';
import 'package:tarkeez/features/others/user_manual/presentation/user_manual_page.dart';
import 'package:tarkeez/features/others/terms_and_conditions/presentation/terms_and_conditions_page.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: RouteNames.home,
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const MainScaffold(),
    ),
    GoRoute(
      path: RouteNames.subscriptionPage,
      builder: (context, state) => const SubscriptionPage(),
    ),
    GoRoute(
      path: RouteNames.userManualPage,
      builder: (context, state) => const UserManualPage(),
    ),

    // ──────────────────────────────────────────────────────────────────────────
    // Others
    // ──────────────────────────────────────────────────────────────────────────
    GoRoute(
      path: RouteNames.feedbackPage,
      builder: (context, state) => const FeedbackPage(),
    ),
    GoRoute(
      path: RouteNames.termsAndConditionsPage,
      builder: (context, state) => const TermsAndConditionsPage(),
    ),
    GoRoute(
      path: RouteNames.userManualPage,
      builder: (context, state) => const UserManualPage(),
    ),
    GoRoute(
      path: RouteNames.hireUsPage,
      builder: (context, state) => const HireUsPage(),
    ),
  ],
);
