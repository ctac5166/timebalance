import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timebalance/data/models/userAppSettingsModel.dart';
import 'package:timebalance/data/models/dayStatsModel.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/objectbox.g.dart';

class UserAppSettingsController extends StateNotifier<UserAppSettingsModel> {
  late Box<UserAppSettingsEntity> settingsBox;
  bool settingsLoaded = false;
  bool guidePlayNow = false;

  bool get isSettingsLoaded => settingsLoaded;
  bool get isGuidePlayNow => guidePlayNow;

  void setGuidePlayVar(bool newValue) {
    guidePlayNow = newValue;
  }

  UserAppSettingsController()
      : super(UserAppSettingsModel(
          isLoaded: false,
          selectedVideoWallpapersName: "",
          appTheme: UserAppThemeType.lightTheme,
          appLanguage: "RU",
          appVersion: "0.0.0.1",
          notifyOneMinuteBeforeEnd: false,
          playSound: true,
          needGuide: true,
          animatedWallpapers: false,
          uploadedWallpapers: false,
          timeFormat24: true,
        )) {
    initObjectBox();
  }

  Future initObjectBox() async {
    final store = objectbox.store;
    settingsBox = store.box<UserAppSettingsEntity>();

    final allSettings = await settingsBox.getAllAsync();
    if (allSettings.isNotEmpty) {
      log("|⚙️|-> найдены существующие настройки");
    }

    UserAppSettingsEntity loadedSettings = allSettings.isNotEmpty
        ? allSettings.first
        : UserAppSettingsEntity(
            appTheme: state.appTheme.toString(),
            selectedVideoWallpapersUrl: state.selectedVideoWallpapersName,
            appLanguage: state.appLanguage,
            appVersion: state.appVersion,
            notifyOneMinuteBeforeEnd: state.notifyOneMinuteBeforeEnd,
            playSound: state.playSound,
            animatedWallpapers: state.animatedWallpapers,
            uploadedWallpapers: state.uploadedWallpapers,
            needGuide: state.needGuide,
            timeFormat24: state.timeFormat24);

    log("|⚙️|-> сохраненные настройки приложения получены");

    UserAppThemeType userAppThemeType = UserAppThemeType.lightTheme;
    switch (loadedSettings.appTheme) {
      case "UserAppThemeType.lightTheme":
        userAppThemeType = UserAppThemeType.lightTheme;
        logger.d("обнаружена lightTheme (${loadedSettings.appTheme})");
        break;
      case "UserAppThemeType.darkTheme":
        userAppThemeType = UserAppThemeType.darkTheme;
        logger.d("обнаружена darkTheme (${loadedSettings.appTheme})");
        break;
      default:
        logger.d("обнаружена неизвестная (${loadedSettings.appTheme})");
        break;
    }
    log("|⚙️|-> сохраненные настройки приложения распарсены");
    log("|⚙️|-> loadedSettings.selectedVideoWallpapersUrl = ${loadedSettings.selectedVideoWallpapersUrl}");
    settingsLoaded = true;
    state = UserAppSettingsModel(
        isLoaded: true,
        appTheme: userAppThemeType,
        selectedVideoWallpapersName: loadedSettings.selectedVideoWallpapersUrl,
        needGuide: loadedSettings.needGuide,
        appLanguage: loadedSettings.appLanguage,
        uploadedWallpapers: loadedSettings.uploadedWallpapers,
        appVersion: loadedSettings.appVersion,
        notifyOneMinuteBeforeEnd: loadedSettings.notifyOneMinuteBeforeEnd,
        playSound: loadedSettings.playSound,
        animatedWallpapers: loadedSettings.animatedWallpapers,
        timeFormat24: loadedSettings.timeFormat24);
  }

  Future saveUserAppSettings(UserAppSettingsModel newSettings) async {
    log("|⚙️|-> newSettings.appTheme = ${newSettings.appTheme}");
    await settingsBox.removeAllAsync();
    UserAppSettingsEntity entity = UserAppSettingsEntity(
        appTheme: newSettings.appTheme.toString(),
        selectedVideoWallpapersUrl: newSettings.selectedVideoWallpapersName,
        uploadedWallpapers: newSettings.uploadedWallpapers,
        needGuide: newSettings.needGuide,
        appLanguage: newSettings.appLanguage,
        appVersion: newSettings.appVersion,
        notifyOneMinuteBeforeEnd: newSettings.notifyOneMinuteBeforeEnd,
        playSound: newSettings.playSound,
        animatedWallpapers: newSettings.animatedWallpapers,
        timeFormat24: newSettings.timeFormat24);
    await settingsBox.putAsync(entity);
    log("|⚙️|-> сохранены новые настройки приложения");
    state = newSettings;
  }
}

final userAppSettingsController =
    StateNotifierProvider<UserAppSettingsController, UserAppSettingsModel>(
        (ref) {
  return UserAppSettingsController();
});
