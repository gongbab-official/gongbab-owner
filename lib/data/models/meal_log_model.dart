import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:json_annotation/json_annotation.dart';

import 'daily_dashboard_model.dart';

part 'meal_log_model.g.dart';

@JsonSerializable()
class MealLogCompanyModel {
  final int id;
  final String name;

  MealLogCompanyModel({
    required this.id,
    required this.name,
  });

  factory MealLogCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$MealLogCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealLogCompanyModelToJson(this);

  MealLogCompany toDomain() {
    return MealLogCompany(
      id: id,
      name: name,
    );
  }
}

@JsonSerializable()
class MealLogItemModel {
  final int mealLogId;
  final String employeeName;
  final String mealType;
  final String time;

  MealLogItemModel({
    required this.mealLogId,
    required this.employeeName,
    required this.mealType,
    required this.time,
  });

  factory MealLogItemModel.fromJson(Map<String, dynamic> json) =>
      _$MealLogItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealLogItemModelToJson(this);

  MealLogItem toDomain() {
    return MealLogItem(
      mealLogId: mealLogId,
      employeeName: employeeName,
      mealType: mealType,
      time: time,
    );
  }
}

@JsonSerializable()
class MealLogModel {
  final String date;
  final MealLogCompanyModel company;
  final int totalCount;
  final DailyDashboardByMealTypeModel byMealType;
  final List<MealLogItemModel> items;

  MealLogModel({
    required this.date,
    required this.company,
    required this.totalCount,
    required this.byMealType,
    required this.items,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) =>
      _$MealLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealLogModelToJson(this);

  MealLog toDomain() {
    return MealLog(
      date: date,
      company: company.toDomain(),
      totalCount: totalCount,
      byMealType: byMealType.toDomain(),
      items: items.map((e) => e.toDomain()).toList(),
    );
  }
}
