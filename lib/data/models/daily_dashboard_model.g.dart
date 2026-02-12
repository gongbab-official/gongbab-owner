// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyDashboardCompanyModel _$DailyDashboardCompanyModelFromJson(
        Map<String, dynamic> json) =>
    DailyDashboardCompanyModel(
      companyId: (json['companyId'] as num).toInt(),
      companyName: json['companyName'] as String,
      meals: (json['meals'] as num).toInt(),
    );

Map<String, dynamic> _$DailyDashboardCompanyModelToJson(
        DailyDashboardCompanyModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'meals': instance.meals,
    };

DailyDashboardByMealTypeModel _$DailyDashboardByMealTypeModelFromJson(
        Map<String, dynamic> json) =>
    DailyDashboardByMealTypeModel(
      additionalProp1: (json['additionalProp1'] as num).toInt(),
      additionalProp2: (json['additionalProp2'] as num).toInt(),
      additionalProp3: (json['additionalProp3'] as num).toInt(),
    );

Map<String, dynamic> _$DailyDashboardByMealTypeModelToJson(
        DailyDashboardByMealTypeModel instance) =>
    <String, dynamic>{
      'additionalProp1': instance.additionalProp1,
      'additionalProp2': instance.additionalProp2,
      'additionalProp3': instance.additionalProp3,
    };

DailyDashboardModel _$DailyDashboardModelFromJson(Map<String, dynamic> json) =>
    DailyDashboardModel(
      date: json['date'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] as String,
      byMealType: DailyDashboardByMealTypeModel.fromJson(
          json['byMealType'] as Map<String, dynamic>),
      totalMeals: (json['totalMeals'] as num).toInt(),
      companies: (json['companies'] as List<dynamic>)
          .map((e) =>
              DailyDashboardCompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyDashboardModelToJson(
        DailyDashboardModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'byMealType': instance.byMealType,
      'totalMeals': instance.totalMeals,
      'companies': instance.companies,
    };
