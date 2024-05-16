import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timebalance/data/models/dayStatsModel.dart';

part 'timerStateModel.freezed.dart';
part 'timerStateModel.g.dart';

@Entity()
class TimerStateEntity {
  int id;
  String currentState;
  int remainingTimeInSeconds;
  String selectedShemeName;
  bool breakStepAutomatically;
  bool workStepAutomatically;
  TimerStateEntity({
    this.id = 0,
    required this.currentState,
    required this.workStepAutomatically,
    required this.breakStepAutomatically,
    required this.remainingTimeInSeconds,
    required this.selectedShemeName,
  });
}

@freezed
class TimerStateModel with _$TimerStateModel {
  factory TimerStateModel({
    required DayStatsModel dayStatistics,
    required StepType currentState,
    required int remainingTimeInSeconds,
    required String selectedShemeName,
    required bool breakStepAutomatically,
    required bool workStepAutomatically,
  }) = _TimerStateModel;

  factory TimerStateModel.fromJson(Map<String, dynamic> json) =>
      _$TimerStateModelFromJson(json);
}

enum StepType {
  off,
  shortBreak,
  longBreak,
  work,
  pause,
  longDelayBeforeWork,
  delayBeforeShortBreak,
  delayBeforeLongBreak,
  delayBeforeWork
}
