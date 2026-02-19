import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/data/auth/auth_token_manager.dart';
import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/domain/usecases/export_monthly_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_monthly_settlement_usecase.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_event.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MonthlySettlementViewModel extends ChangeNotifier {
  final AuthTokenManager _authTokenManager;
  final GetMonthlySettlementUseCase _getMonthlySettlementUseCase;
  final ExportMonthlySettlementUseCase _exportMonthlySettlementUseCase;

  MonthlySettlementUiState _uiState = Initial();

  MonthlySettlementUiState get uiState => _uiState;

  MonthlySettlementViewModel(
    this._authTokenManager,
    this._getMonthlySettlementUseCase,
    this._exportMonthlySettlementUseCase,
  );

  void onEvent(MonthlySettlementEvent event) {
    if (event is LoadMonthlySettlement) {
      _loadMonthlySettlement(
        month: event.month,
      );
    } else if (event is ExportMonthlySettlement) {
      _exportMonthlySettlement(
        month: event.month,
      );
    }
  }

  Future<void> _loadMonthlySettlement({
    required String month,
  }) async {
    _uiState = Loading();
    notifyListeners();

    final String? restaurantId = _authTokenManager.getRestaurantId()?.toString();

    if (restaurantId == null) {
      _uiState = Error('Restaurant ID not found. Please log in again.');
      notifyListeners();
      return;
    }

    final result = await _getMonthlySettlementUseCase.execute(
      restaurantId: restaurantId,
      month: month,
    );

    result.when(
      success: (monthlySettlement) {
        _uiState = Success(monthlySettlement);
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

  Future<void> _exportMonthlySettlement({
    required String month,
  }) async {
    MonthlySettlement? currentSettlement;
    if (_uiState is Success) {
      currentSettlement = (_uiState as Success).monthlySettlement;
      _uiState = Exporting(currentSettlement);
    } else if (_uiState is ExportSuccess) {
      currentSettlement = (_uiState as ExportSuccess).monthlySettlement;
      _uiState = Exporting(currentSettlement);
    } else if (_uiState is ExportError) {
      currentSettlement = (_uiState as ExportError).monthlySettlement;
      _uiState = Exporting(currentSettlement);
    } else {
      _uiState = Error('No settlement data available to export. Please load it first.');
      notifyListeners();
      return;
    }
    notifyListeners();

    final String? restaurantId = _authTokenManager.getRestaurantId()?.toString();

    if (restaurantId == null) {
      _uiState = ExportError('Restaurant ID not found. Please log in again.', currentSettlement!);
      notifyListeners();
      return;
    }

    final result = await _exportMonthlySettlementUseCase.execute(
      restaurantId: restaurantId,
      month: month,
    );

    result.when(
      success: (data) async {
        try {
          final String fileName = 'settlement_$month.xlsx';
          final path = await FileSaver.instance.saveFile(
            name: fileName,
            bytes: data,
            mimeType: MimeType.microsoftExcel,
          );
          _uiState = ExportSuccess('파일이 성공적으로 저장되었습니다.\n경로: $path', currentSettlement!);
        } catch (e) {
          _uiState = ExportError('파일 저장에 실패했습니다: ${e.toString()}', currentSettlement!);
        }
        notifyListeners();
      },
      failure: (success, error) {
        _uiState = ExportError(error?['message'] ?? 'Export failed.', currentSettlement!);
        notifyListeners();
      },
      error: (message) {
        _uiState = ExportError('Export failed: $message', currentSettlement!);
        notifyListeners();
      },
    );
  }
}
