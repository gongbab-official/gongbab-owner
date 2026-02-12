import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';
import 'package:gongbab_owner/domain/repositories/dashboard_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDailyDashboardUseCase {
  final DashboardRepository _dashboardRepository;

  GetDailyDashboardUseCase(this._dashboardRepository);

  Future<Result<DailyDashboard>> execute({
    required String restaurantId,
    required String date,
  }) {
    return _dashboardRepository.getDailyDashboard(
      restaurantId: restaurantId,
      date: date,
    );
  }
}
