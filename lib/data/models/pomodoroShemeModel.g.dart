// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoroShemeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PomodoroShemeModelImpl _$$PomodoroShemeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PomodoroShemeModelImpl(
      shemeName: json['shemeName'] as String,
      breakTimeInSeconds: (json['breakTimeInSeconds'] as num).toInt(),
      shortBreakTimeInSeconds: (json['shortBreakTimeInSeconds'] as num).toInt(),
      workSessionTimeInSeconds:
          (json['workSessionTimeInSeconds'] as num).toInt(),
      numberOfSessionsBeforeLongBreak:
          (json['numberOfSessionsBeforeLongBreak'] as num).toInt(),
    );

Map<String, dynamic> _$$PomodoroShemeModelImplToJson(
        _$PomodoroShemeModelImpl instance) =>
    <String, dynamic>{
      'shemeName': instance.shemeName,
      'breakTimeInSeconds': instance.breakTimeInSeconds,
      'shortBreakTimeInSeconds': instance.shortBreakTimeInSeconds,
      'workSessionTimeInSeconds': instance.workSessionTimeInSeconds,
      'numberOfSessionsBeforeLongBreak':
          instance.numberOfSessionsBeforeLongBreak,
    };
