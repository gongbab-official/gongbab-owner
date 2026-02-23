import '../dashboard/daily_dashboard.dart';

class MealLogCompany {
  final int id;
  final String name;

  MealLogCompany({
    required this.id,
    required this.name,
  });
}

class MealLogItem {
  final int mealLogId;
  final String employeeName;
  final String mealType;
  final String time;

  MealLogItem({
    required this.mealLogId,
    required this.employeeName,
    required this.mealType,
    required this.time,
  });
}

class MealLog {
  final String date;
  final MealLogCompany company;
  final int totalCount;
  final DailyDashboardByMealType byMealType;
  final List<MealLogItem> items;

  MealLog({
    required this.date,
    required this.company,
    required this.totalCount,
    required this.byMealType,
    required this.items,
  });
}
