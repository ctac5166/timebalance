// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soundControllerStateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SoundControllerStateModelImpl _$$SoundControllerStateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SoundControllerStateModelImpl(
      breakSound: json['breakSound'] as String,
      workSound: json['workSound'] as String,
      playWorkSound: json['playWorkSound'] as bool,
      playBreakSound: json['playBreakSound'] as bool,
      soundsVolume: (json['soundsVolume'] as num).toDouble(),
    );

Map<String, dynamic> _$$SoundControllerStateModelImplToJson(
        _$SoundControllerStateModelImpl instance) =>
    <String, dynamic>{
      'breakSound': instance.breakSound,
      'workSound': instance.workSound,
      'playWorkSound': instance.playWorkSound,
      'playBreakSound': instance.playBreakSound,
      'soundsVolume': instance.soundsVolume,
    };
