import 'package:objectbox/objectbox.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'soundSettingsModel.freezed.dart';
part 'soundSettingsModel.g.dart';

@Entity()
class SoundSettingsEntity {
  int id;

  double volumeLevel;
  bool soundBeforeWork;
  String soundBeforeWorkName;
  bool soundBeforeShortBreak;
  String soundBeforeShortBreakName;
  bool soundBeforeLongBreak;
  String soundBeforeLongBreakName;

  SoundSettingsEntity({
    this.id = 0,
    required this.volumeLevel,
    required this.soundBeforeWork,
    required this.soundBeforeWorkName,
    required this.soundBeforeShortBreak,
    required this.soundBeforeShortBreakName,
    required this.soundBeforeLongBreak,
    required this.soundBeforeLongBreakName,
  });
}

@freezed
class SoundSettingsModel with _$SoundSettingsModel {
  factory SoundSettingsModel({
    required double volumeLevel,
    required bool soundBeforeWork,
    required String soundBeforeWorkName,
    required bool soundBeforeShortBreak,
    required String soundBeforeShortBreakName,
    required bool soundBeforeLongBreak,
    required String soundBeforeLongBreakName,
  }) = _SoundSettingsModel;

  factory SoundSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SoundSettingsModelFromJson(json);
}
