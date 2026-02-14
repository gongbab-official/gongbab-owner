abstract class CompanyMealDetailEvent {}

class LoadMealLogs extends CompanyMealDetailEvent {
  final int companyId;
  final String date;

  LoadMealLogs({required this.companyId, required this.date});
}
