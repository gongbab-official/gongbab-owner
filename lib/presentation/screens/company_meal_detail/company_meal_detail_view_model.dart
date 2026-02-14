import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/data/auth/auth_token_manager.dart';
import 'package:gongbab_owner/domain/usecases/get_meal_logs_usecase.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompanyMealDetailViewModel extends ChangeNotifier {
  final AuthTokenManager _authTokenManager;
  final GetMealLogsUseCase _getMealLogsUseCase;

  CompanyMealDetailUiState _uiState = Initial();

  CompanyMealDetailUiState get uiState => _uiState;

  CompanyMealDetailViewModel(
    this._authTokenManager,
    this._getMealLogsUseCase,
  );

  void onEvent(CompanyMealDetailEvent event) {
    if (event is LoadMealLogs) {
      _loadMealLogs(
        companyId: event.companyId,
        date: event.date,
      );
    }
  }

  Future<void> _loadMealLogs({
    required int companyId,
    required String date,
  }) async {
    _uiState = Loading();
    notifyListeners();

    final String? restaurantId = _authTokenManager.getRestaurantId()?.toString();

    if (restaurantId == null) {
      _uiState = Error('Restaurant ID not found. Please log in again.');
      notifyListeners();
      return;
    }

    final result = await _getMealLogsUseCase.execute(
      restaurantId: restaurantId,
      companyId: companyId.toString(), // Convert int to String
      date: date,
    );

    result.when(
      success: (mealLog) {
        _uiState = Success(mealLog);
        notifyListeners();
      },
      failure: (success, error) {
        _uiState = Error(error?['message'] ?? 'Unknown error');
        notifyListeners();
      },
      error: (message) {
        _uiState = Error(message);
        notifyListeners();
      },
    );
  }
}
