// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userAppSettingsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserAppSettingsModelImpl _$$UserAppSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserAppSettingsModelImpl(
      appTheme: $enumDecode(_$UserAppThemeTypeEnumMap, json['appTheme']),
      appLanguage: json['appLanguage'] as String,
      appVersion: json['appVersion'] as String,
      selectedVideoWallpapersName:
          json['selectedVideoWallpapersName'] as String,
      notifyOneMinuteBeforeEnd: json['notifyOneMinuteBeforeEnd'] as bool,
      playSound: json['playSound'] as bool,
      animatedWallpapers: json['animatedWallpapers'] as bool,
      uploadedWallpapers: json['uploadedWallpapers'] as bool,
      timeFormat24: json['timeFormat24'] as bool,
      needGuide: json['needGuide'] as bool,
      isLoaded: json['isLoaded'] as bool,
      isWallpaperLoading: json['isWallpaperLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserAppSettingsModelImplToJson(
        _$UserAppSettingsModelImpl instance) =>
    <String, dynamic>{
      'appTheme': _$UserAppThemeTypeEnumMap[instance.appTheme]!,
      'appLanguage': instance.appLanguage,
      'appVersion': instance.appVersion,
      'selectedVideoWallpapersName': instance.selectedVideoWallpapersName,
      'notifyOneMinuteBeforeEnd': instance.notifyOneMinuteBeforeEnd,
      'playSound': instance.playSound,
      'animatedWallpapers': instance.animatedWallpapers,
      'uploadedWallpapers': instance.uploadedWallpapers,
      'timeFormat24': instance.timeFormat24,
      'needGuide': instance.needGuide,
      'isLoaded': instance.isLoaded,
      'isWallpaperLoading': instance.isWallpaperLoading,
    };

const _$UserAppThemeTypeEnumMap = {
  UserAppThemeType.darkTheme: 'darkTheme',
  UserAppThemeType.lightTheme: 'lightTheme',
};
