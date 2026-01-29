import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          // TODO: Implement LoginScreen
          return const Text('Login Screen'); // Placeholder
        },
      ),
      // Add other routes here
    ],
  );
}