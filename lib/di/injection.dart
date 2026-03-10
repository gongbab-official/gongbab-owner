import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gongbab_owner/di/injection.config.dart';
import 'package:gongbab_owner/domain/repositories/dashboard_repository.dart';
import 'package:gongbab_owner/domain/usecases/get_daily_dashboard_usecase.dart';
import 'package:gongbab_owner/domain/repositories/meal_log_repository.dart';
import 'package:gongbab_owner/domain/usecases/get_meal_logs_usecase.dart';
import 'package:gongbab_owner/domain/repositories/settlement_repository.dart';
import 'package:gongbab_owner/domain/usecases/confirm_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/create_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/export_monthly_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_monthly_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_settlement_detail_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_settlements_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth/auth_token_manager.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  LoginUseCase loginUseCase(AuthRepository repository, AuthTokenManager authTokenManager) {
    return LoginUseCase(repository, authTokenManager);
  }

  @lazySingleton
  GetDailyDashboardUseCase getDailyDashboardUseCase(DashboardRepository repository) {
    return GetDailyDashboardUseCase(repository);
  }

  @lazySingleton
  GetMealLogsUseCase getMealLogsUseCase(MealLogRepository repository) {
    return GetMealLogsUseCase(repository);
  }

  @lazySingleton
  GetMonthlySettlementUseCase getMonthlySettlementUseCase(SettlementRepository repository) {
    return GetMonthlySettlementUseCase(repository);
  }

  @lazySingleton
  GetSettlementsUseCase getSettlementsUseCase(SettlementRepository repository) {
    return GetSettlementsUseCase(repository);
  }

  @lazySingleton
  CreateSettlementUseCase createSettlementUseCase(SettlementRepository repository) {
    return CreateSettlementUseCase(repository);
  }

  @lazySingleton
  GetSettlementDetailUseCase getSettlementDetailUseCase(SettlementRepository repository) {
    return GetSettlementDetailUseCase(repository);
  }

  @lazySingleton
  ConfirmSettlementUseCase confirmSettlementUseCase(SettlementRepository repository) {
    return ConfirmSettlementUseCase(repository);
  }

  @lazySingleton
  ExportMonthlySettlementUseCase exportMonthlySettlementUseCase(SettlementRepository repository) {
    return ExportMonthlySettlementUseCase(repository);
  }

  @lazySingleton // Provide Dio instance
  Dio get dio => Dio();
}