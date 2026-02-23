// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealLogCompanyModel _$MealLogCompanyModelFromJson(Map<String, dynamic> json) =>
    MealLogCompanyModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$MealLogCompanyModelToJson(
        MealLogCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MealLogItemModel _$MealLogItemModelFromJson(Map<String, dynamic> json) =>
    MealLogItemModel(
      mealLogId: (json['mealLogId'] as num).toInt(),
      employeeName: json['employeeName'] as String,
      mealType: json['mealType'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$MealLogItemModelToJson(MealLogItemModel instance) =>
    <String, dynamic>{
      'mealLogId': instance.mealLogId,
      'employeeName': instance.employeeName,
      'mealType': instance.mealType,
      'time': instance.time,
    };

MealLogModel _$MealLogModelFromJson(Map<String, dynamic> json) => MealLogModel(
      date: json['date'] as String,
      company:
          MealLogCompanyModel.fromJson(json['company'] as Map<String, dynamic>),
      totalCount: (json['totalCount'] as num).toInt(),
      byMealType: DailyDashboardByMealTypeModel.fromJson(
          json['byMealType'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => MealLogItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealLogModelToJson(MealLogModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'company': instance.company,
      'totalCount': instance.totalCount,
      'byMealType': instance.byMealType,
      'items': instance.items,
    };
