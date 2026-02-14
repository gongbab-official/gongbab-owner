import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';

abstract class CompanyMealDetailUiState {}

class Initial extends CompanyMealDetailUiState {}

class Loading extends CompanyMealDetailUiState {}

class Success extends CompanyMealDetailUiState {
  final MealLog mealLog;

  Success(this.mealLog);
}

class Error extends CompanyMealDetailUiState {
  final String message;

  Error(this.message);
}
