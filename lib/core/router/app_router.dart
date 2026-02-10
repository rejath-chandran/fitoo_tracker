import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/workout/workout_screen.dart';
import '../../features/workouts_list/workouts_list_screen.dart';
import '../../features/workouts_list/template_detail_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../widgets/app_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workouts',
              builder: (context, state) => const WorkoutsListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Full-screen route — no bottom nav
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/workout/active',
      builder: (context, state) {
        final templateIdStr = state.uri.queryParameters['templateId'];
        final templateId = templateIdStr != null
            ? int.tryParse(templateIdStr)
            : null;
        return WorkoutScreen(templateId: templateId);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/workouts/template/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TemplateDetailScreen(templateId: id);
      },
    ),
  ],
);
