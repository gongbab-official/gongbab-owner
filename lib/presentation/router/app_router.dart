import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_screen.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_screen.dart';
import 'package:gongbab_owner/presentation/screens/login/login_screen.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_screen.dart';

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
      GoRoute(
        path: AppRoutes.dailyMealCountStatus,
        builder: (BuildContext context, GoRouterState state) {
          return const DailyMealCountStatusScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.companyMealDetail,
        builder: (BuildContext context, GoRouterState state) {
          return CompanyMealDetailScreen(
            companyName: state.pathParameters['companyName'] ?? '',
            selectedDate: state.pathParameters['email'] as DateTime? ?? DateTime.now(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.monthlySettlement,
        builder: (BuildContext context, GoRouterState state) {
          return const MonthlySettlementScreen();
        },
      ),
      // Add other routes here
    ],
  );
}
