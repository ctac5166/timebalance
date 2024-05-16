// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dayStatsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayStatsModelImpl _$$DayStatsModelImplFromJson(Map<String, dynamic> json) =>
    _$DayStatsModelImpl(
      shemeName: json['shemeName'] as String,
      statsDate: DateTime.parse(json['statsDate'] as String),
      maximumWorkTimeDuringThisInterval:
          (json['maximumWorkTimeDuringThisInterval'] as num).toInt(),
      totalWorkTimeForTheEntireInterval:
          (json['totalWorkTimeForTheEntireInterval'] as num).toInt(),
    );

Map<String, dynamic> _$$DayStatsModelImplToJson(_$DayStatsModelImpl instance) =>
    <String, dynamic>{
      'shemeName': instance.shemeName,
      'statsDate': instance.statsDate.toIso8601String(),
      'maximumWorkTimeDuringThisInterval':
          instance.maximumWorkTimeDuringThisInterval,
      'totalWorkTimeForTheEntireInterval':
          instance.totalWorkTimeForTheEntireInterval,
    };
