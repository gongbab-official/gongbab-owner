sealed class SettlementRegisterEvent {
  const SettlementRegisterEvent();
}

class LoadSettlementForMonth extends SettlementRegisterEvent {
  final int year;
  final int month;

  const LoadSettlementForMonth({required this.year, required this.month});
}

class SaveSettlement extends SettlementRegisterEvent {
  final int year;
  final int month;
  final List<Map<String, dynamic>> items;

  const SaveSettlement({
    required this.year,
    required this.month,
    required this.items,
  });
}
