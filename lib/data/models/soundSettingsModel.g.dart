// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundSettingsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SoundSettingsModelImpl _$$SoundSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SoundSettingsModelImpl(
      volumeLevel: (json['volumeLevel'] as num).toDouble(),
      soundBeforeWork: json['soundBeforeWork'] as bool,
      soundBeforeWorkName: json['soundBeforeWorkName'] as String,
      soundBeforeShortBreak: json['soundBeforeShortBreak'] as bool,
      soundBeforeShortBreakName: json['soundBeforeShortBreakName'] as String,
      soundBeforeLongBreak: json['soundBeforeLongBreak'] as bool,
      soundBeforeLongBreakName: json['soundBeforeLongBreakName'] as String,
    );

Map<String, dynamic> _$$SoundSettingsModelImplToJson(
        _$SoundSettingsModelImpl instance) =>
    <String, dynamic>{
      'volumeLevel': instance.volumeLevel,
      'soundBeforeWork': instance.soundBeforeWork,
      'soundBeforeWorkName': instance.soundBeforeWorkName,
      'soundBeforeShortBreak': instance.soundBeforeShortBreak,
      'soundBeforeShortBreakName': instance.soundBeforeShortBreakName,
      'soundBeforeLongBreak': instance.soundBeforeLongBreak,
      'soundBeforeLongBreakName': instance.soundBeforeLongBreakName,
    };
