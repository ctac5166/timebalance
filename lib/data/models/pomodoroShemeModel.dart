import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'pomodoroShemeModel.freezed.dart';
part 'pomodoroShemeModel.g.dart';

@Entity()
class PomodoroShemeEntity {
  int id;
  String shemeName;
  int breakTimeInSeconds;
  int shortBreakTimeInSeconds;
  int workSessionTimeInSeconds;
  int numberOfSessionsBeforeLongBreak;
  PomodoroShemeEntity({
    this.id = 0,
    required this.shemeName,
    required this.breakTimeInSeconds,
    required this.shortBreakTimeInSeconds,
    required this.workSessionTimeInSeconds,
    required this.numberOfSessionsBeforeLongBreak,
  });
}

@freezed
class PomodoroShemeModel with _$PomodoroShemeModel {
  factory PomodoroShemeModel({
    required String shemeName,
    required int breakTimeInSeconds,
    required int shortBreakTimeInSeconds,
    required int workSessionTimeInSeconds,
    required int numberOfSessionsBeforeLongBreak,
  }) = _PomodoroShemeModel;

  factory PomodoroShemeModel.fromJson(Map<String, dynamic> json) =>
      _$PomodoroShemeModelFromJson(json);
}
