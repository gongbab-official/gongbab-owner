import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';

sealed class SettlementManagementUiState {
  const SettlementManagementUiState();
}

class SettlementManagementInitial extends SettlementManagementUiState {
  const SettlementManagementInitial();
}

class SettlementManagementLoading extends SettlementManagementUiState {
  const SettlementManagementLoading();
}

class SettlementManagementSuccess extends SettlementManagementUiState {
  final List<Settlement> settlements;

  const SettlementManagementSuccess(this.settlements);
}

class SettlementManagementError extends SettlementManagementUiState {
  final String message;

  const SettlementManagementError(this.message);
}
