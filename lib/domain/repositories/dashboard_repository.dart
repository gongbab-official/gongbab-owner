import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

abstract class DashboardRepository {
  Future<Result<DailyDashboard>> getDailyDashboard({
    required int restaurantId,
    required String date,
  });
}
