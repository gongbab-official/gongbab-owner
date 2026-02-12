import 'package:gongbab_owner/data/network/api_service.dart';
import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';
import 'package:gongbab_owner/domain/repositories/dashboard_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _apiService;

  DashboardRepositoryImpl(this._apiService);

  @override
  Future<Result<DailyDashboard>> getDailyDashboard({
    required String restaurantId,
    required String date,
  }) async {
    final result = await _apiService.getDailyDashboard(
        restaurantId: restaurantId, date: date);
    return result.when(
      success: (model) => Success(model.toDomain()),
      failure: (success, error) => Failure(success, error),
      error: (error) => Error(error),
    );
  }
}
