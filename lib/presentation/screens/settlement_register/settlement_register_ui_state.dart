import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';

sealed class SettlementRegisterUiState {
  const SettlementRegisterUiState();
}

class SettlementRegisterInitial extends SettlementRegisterUiState {
  const SettlementRegisterInitial();
}

class SettlementRegisterLoading extends SettlementRegisterUiState {
  const SettlementRegisterLoading();
}

class SettlementRegisterSuccess extends SettlementRegisterUiState {
  final Settlement? settlement;

  const SettlementRegisterSuccess(this.settlement);
}

class SettlementRegisterError extends SettlementRegisterUiState {
  final String message;

  const SettlementRegisterError(this.message);
}

class SettlementSaveSuccess extends SettlementRegisterUiState {
  const SettlementSaveSuccess();
}
