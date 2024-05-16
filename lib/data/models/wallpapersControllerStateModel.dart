import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallpapersControllerStateModel.freezed.dart';
part 'wallpapersControllerStateModel.g.dart';

enum WallpapersState {
  download,
  appearing,
  disappear,
  off,
  playing,
}

@freezed
class WallpapersControllerStateModel with _$WallpapersControllerStateModel {
  factory WallpapersControllerStateModel({
    required WallpapersState state,
    required int loadingProcent,
    required String linkToCurrentWallpaper,
    required String fullPathToCurrentWallpapers,
  }) = _WallpapersControllerStateModel;

  factory WallpapersControllerStateModel.fromJson(Map<String, dynamic> json) =>
      _$WallpapersControllerStateModelFromJson(json);
}
