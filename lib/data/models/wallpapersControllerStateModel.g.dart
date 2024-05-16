// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpapersControllerStateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WallpapersControllerStateModelImpl
    _$$WallpapersControllerStateModelImplFromJson(Map<String, dynamic> json) =>
        _$WallpapersControllerStateModelImpl(
          state: $enumDecode(_$WallpapersStateEnumMap, json['state']),
          loadingProcent: (json['loadingProcent'] as num).toInt(),
          linkToCurrentWallpaper: json['linkToCurrentWallpaper'] as String,
          fullPathToCurrentWallpapers:
              json['fullPathToCurrentWallpapers'] as String,
        );

Map<String, dynamic> _$$WallpapersControllerStateModelImplToJson(
        _$WallpapersControllerStateModelImpl instance) =>
    <String, dynamic>{
      'state': _$WallpapersStateEnumMap[instance.state]!,
      'loadingProcent': instance.loadingProcent,
      'linkToCurrentWallpaper': instance.linkToCurrentWallpaper,
      'fullPathToCurrentWallpapers': instance.fullPathToCurrentWallpapers,
    };

const _$WallpapersStateEnumMap = {
  WallpapersState.download: 'download',
  WallpapersState.appearing: 'appearing',
  WallpapersState.disappear: 'disappear',
  WallpapersState.off: 'off',
  WallpapersState.playing: 'playing',
};
