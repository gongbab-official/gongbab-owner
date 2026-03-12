import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/domain/usecases/create_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_settlement_detail_usecase.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettlementRegisterViewModel extends ChangeNotifier {
  final GetSettlementDetailUseCase _getSettlementDetailUseCase;
  final CreateSettlementUseCase _createSettlementUseCase;

  SettlementRegisterViewModel(
    this._getSettlementDetailUseCase,
    this._createSettlementUseCase,
  );

  SettlementRegisterUiState _uiState = const SettlementRegisterInitial();
  SettlementRegisterUiState get uiState => _uiState;

  void onEvent(SettlementRegisterEvent event) {
    if (event is LoadSettlementForMonth) {
      _loadSettlement(event.year, event.month);
    } else if (event is SaveSettlement) {
      _saveSettlement(event.year, event.month, event.items);
    }
  }

  Future<void> _loadSettlement(int year, int month) async {
    _uiState = const SettlementRegisterLoading();
    notifyListeners();

    final result = await _getSettlementDetailUseCase.execute(year: year, month: month);

    result.when(
      success: (settlement) {
        _uiState = SettlementRegisterSuccess(settlement);
      },
      failure: (success, error) {
        // SETTLEMENT_NOT_FOUND error case means no data yet for the month
        if (error?['code'] == 'SETTLEMENT_NOT_FOUND') {
          _uiState = const SettlementRegisterSuccess(null);
        } else {
          _uiState = SettlementRegisterError(error?['message'] ?? '정산 정보를 불러오지 못했습니다.');
        }
      },
      error: (error) {
        _uiState = SettlementRegisterError(error);
      },
    );
    notifyListeners();
  }

  Future<void> _saveSettlement(int year, int month, List<Map<String, dynamic>> items) async {
    _uiState = const SettlementRegisterLoading();
    notifyListeners();

    final result = await _createSettlementUseCase.execute(
      year: year,
      month: month,
      items: items,
    );

    result.when(
      success: (settlement) {
        _uiState = const SettlementSaveSuccess();
      },
      failure: (success, error) {
        _uiState = SettlementRegisterError(error?['message'] ?? '정산 저장에 실패했습니다.');
      },
      error: (error) {
        _uiState = SettlementRegisterError(error);
      },
    );
    notifyListeners();
  }
}
