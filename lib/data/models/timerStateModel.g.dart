// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timerStateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerStateModelImpl _$$TimerStateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TimerStateModelImpl(
      dayStatistics:
          DayStatsModel.fromJson(json['dayStatistics'] as Map<String, dynamic>),
      currentState: $enumDecode(_$StepTypeEnumMap, json['currentState']),
      remainingTimeInSeconds: (json['remainingTimeInSeconds'] as num).toInt(),
      selectedShemeName: json['selectedShemeName'] as String,
      breakStepAutomatically: json['breakStepAutomatically'] as bool,
      workStepAutomatically: json['workStepAutomatically'] as bool,
    );

Map<String, dynamic> _$$TimerStateModelImplToJson(
        _$TimerStateModelImpl instance) =>
    <String, dynamic>{
      'dayStatistics': instance.dayStatistics,
      'currentState': _$StepTypeEnumMap[instance.currentState]!,
      'remainingTimeInSeconds': instance.remainingTimeInSeconds,
      'selectedShemeName': instance.selectedShemeName,
      'breakStepAutomatically': instance.breakStepAutomatically,
      'workStepAutomatically': instance.workStepAutomatically,
    };

const _$StepTypeEnumMap = {
  StepType.off: 'off',
  StepType.shortBreak: 'shortBreak',
  StepType.longBreak: 'longBreak',
  StepType.work: 'work',
  StepType.pause: 'pause',
  StepType.longDelayBeforeWork: 'longDelayBeforeWork',
  StepType.delayBeforeShortBreak: 'delayBeforeShortBreak',
  StepType.delayBeforeLongBreak: 'delayBeforeLongBreak',
  StepType.delayBeforeWork: 'delayBeforeWork',
};
