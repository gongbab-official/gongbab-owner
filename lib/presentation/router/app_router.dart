import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:gongbab_owner/presentation/screens/login/login_screen.dart';

part 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      // Add other routes here
    ],
  );
}