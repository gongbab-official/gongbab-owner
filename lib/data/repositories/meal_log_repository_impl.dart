import 'package:gongbab_owner/data/network/api_service.dart';
import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/domain/repositories/meal_log_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MealLogRepository)
class MealLogRepositoryImpl implements MealLogRepository {
  final ApiService _apiService;

  MealLogRepositoryImpl(this._apiService);

  @override
  Future<Result<MealLog>> getMealLogs({
    required String restaurantId,
    required String companyId,
    required String date,
    required String mealType,
    String? q,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await _apiService.getMealLogs(
      restaurantId: restaurantId,
      companyId: companyId,
      date: date,
      mealType: mealType,
      q: q,
      page: page,
      pageSize: pageSize,
    );
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }
}
