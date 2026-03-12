import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/domain/usecases/get_settlements_usecase.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_management/settlement_management_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettlementManagementViewModel extends ChangeNotifier {
  final GetSettlementsUseCase _getSettlementsUseCase;

  SettlementManagementViewModel(this._getSettlementsUseCase);

  SettlementManagementUiState _uiState = const SettlementManagementInitial();
  SettlementManagementUiState get uiState => _uiState;

  void onEvent(SettlementManagementEvent event) {
    if (event is LoadSettlements) {
      _loadSettlements();
    }
  }

  Future<void> _loadSettlements() async {
    _uiState = const SettlementManagementLoading();
    notifyListeners();

    final result = await _getSettlementsUseCase.execute();

    result.when(
      success: (settlements) {
        _uiState = SettlementManagementSuccess(settlements);
      },
      failure: (success, error) {
        _uiState = SettlementManagementError(error?['message'] ?? '정산 정보를 불러오지 못했습니다.');
      },
      error: (error) {
        _uiState = SettlementManagementError(error);
      },
    );
    notifyListeners();
  }
}
