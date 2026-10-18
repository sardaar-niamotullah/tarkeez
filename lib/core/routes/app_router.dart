import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/routes/router_refresh_stream.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:tarkeez/features/auth/presentation/auth_page.dart';
import 'package:tarkeez/features/main_scaffold.dart';
import 'package:tarkeez/features/others/feedback/presentation/feedback_page.dart';
import 'package:tarkeez/features/others/hire_us/presentation/hire_us_page.dart';
import 'package:tarkeez/features/others/terms_and_conditions/presentation/terms_and_conditions_page.dart';
import 'package:tarkeez/features/others/user_manual/presentation/user_manual_page.dart';
import 'package:tarkeez/features/sessions/presentation/sessions_page.dart';
import 'package:tarkeez/features/subscription/presentation/subscription_page.dart';

const _publicRoutes = {
  RouteNames.termsAndConditionsPage,
  RouteNames.feedbackPage,
};

final GoRouter router = _buildRouter();

GoRouter _buildRouter() {
  final authBloc = getIt<AuthBloc>();

  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: RouteNames.home,
    refreshListenable: RouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final onAuthPage = location == RouteNames.authPage;
      final isPublic = _publicRoutes.contains(location);

      if (authState is AuthSuccess) {
        return onAuthPage ? RouteNames.home : null;
      }
      if (authState is AuthInitial || authState is AuthSignOut) {
        return (onAuthPage || isPublic) ? null : RouteNames.authPage;
      }
      return null; // AuthLoading / AuthFailure: stay put
    },
    routes: [
      GoRoute(
        path: RouteNames.authPage,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: RouteNames.sessions,
        builder: (context, state) => const SessionsPage(),
      ),
      GoRoute(
        path: RouteNames.subscriptionPage,
        builder: (context, state) => const SubscriptionPage(),
      ),
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
}
