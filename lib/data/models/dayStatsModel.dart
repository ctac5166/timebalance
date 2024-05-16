import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'dayStatsModel.freezed.dart';
part 'dayStatsModel.g.dart';

@Entity()
class DayStatsEntity {
  int id;
  String shemeName;
  @Property(type: PropertyType.date)
  DateTime statsDate;
  int maximumWorkTimeDuringThisInterval;
  int totalWorkTimeForTheEntireInterval;
  DayStatsEntity({
    this.id = 0,
    required this.shemeName,
    required this.statsDate,
    required this.maximumWorkTimeDuringThisInterval,
    required this.totalWorkTimeForTheEntireInterval,
  });
  double get concentrationPercentage => (maximumWorkTimeDuringThisInterval > 0)
      ? (totalWorkTimeForTheEntireInterval /
              maximumWorkTimeDuringThisInterval) *
          100
      : 0;
}

@freezed
class DayStatsModel with _$DayStatsModel {
  factory DayStatsModel({
    required String shemeName,
    required DateTime statsDate,
    required int maximumWorkTimeDuringThisInterval,
    required int totalWorkTimeForTheEntireInterval,
  }) = _DayStatsModel;

  factory DayStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DayStatsModelFromJson(json);
}
