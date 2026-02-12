import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

abstract class MealLogRepository {
  Future<Result<MealLog>> getMealLogs({
    required String restaurantId,
    required String companyId,
    required String date,
    required String mealType,
    String? q,
    int page = 1,
    int pageSize = 20,
  });
}
