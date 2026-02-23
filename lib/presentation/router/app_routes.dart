part of 'app_router.dart';

abstract class AppRoutes {
  static const String login = '/login';
  static const String dailyMealCountStatus = '/daily_meal_count_status';
  static const String companyMealDetail =
      '/company_meal_detail/:companyId/:companyName/:selectedDate';
  static const String monthlySettlement = '/monthly_settlement';
  // Add other routes here
}