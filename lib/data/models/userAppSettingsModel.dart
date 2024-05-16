import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'userAppSettingsModel.freezed.dart';
part 'userAppSettingsModel.g.dart';

@Entity()
class UserAppSettingsEntity {
  @Id()
  int id = 0;
  String appTheme;
  String appLanguage;
  String appVersion;
  String selectedVideoWallpapersUrl;
  bool notifyOneMinuteBeforeEnd;
  bool playSound;
  bool animatedWallpapers;
  bool uploadedWallpapers;
  bool timeFormat24;
  bool needGuide;

  UserAppSettingsEntity({
    required this.appTheme,
    required this.appLanguage,
    required this.appVersion,
    required this.selectedVideoWallpapersUrl,
    required this.notifyOneMinuteBeforeEnd,
    required this.playSound,
    required this.needGuide,
    required this.animatedWallpapers,
    required this.uploadedWallpapers,
    required this.timeFormat24,
  });
}

enum UserAppThemeType { darkTheme, lightTheme }

@freezed
class UserAppSettingsModel with _$UserAppSettingsModel {
  factory UserAppSettingsModel({
    required UserAppThemeType appTheme, // lightTheme
    required String appLanguage, // RU
    required String appVersion, // 0.0.0.1
    required String selectedVideoWallpapersName,
    required bool notifyOneMinuteBeforeEnd, // false
    required bool playSound, // true
    required bool animatedWallpapers, // false
    required bool uploadedWallpapers, // false
    required bool timeFormat24, // true
    required bool needGuide,
    required bool isLoaded,
    @Default(false) bool isWallpaperLoading,
  }) = _UserAppSettingsModel;

  factory UserAppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserAppSettingsModelFromJson(json);
}
