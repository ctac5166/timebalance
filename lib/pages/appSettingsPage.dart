// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:themed/themed.dart';

import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/controllers/videoWallpaperManagerProvider.dart';
import 'package:timebalance/data/models/userAppSettingsModel.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/glassContainer.dart';

@RoutePage()
class AppSettingsPage extends ConsumerStatefulWidget {
  const AppSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSettingsPageState();
}

class Wallpaper {
  String url;
  String name;
  bool isSelected;

  Wallpaper(
    this.url,
    this.name,
    this.isSelected,
  );
}

class _AppSettingsPageState extends ConsumerState<AppSettingsPage> {
  List<Wallpaper> animatedWallpapersUrlList = [
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%B3%D0%BE%D1%80%D1%8B%20%D0%B8%20%D0%BD%D0%B5%D0%B1%D0%BE.mp4?alt=media&token=8bc7b674-e6f3-48fd-a637-c157795945ea",
        "горы",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%B7%D0%B2%D0%B5%D0%B7%D0%B4%D1%8B.mp4?alt=media&token=4ee7503f-485b-4207-ae71-6ce0f805ae87",
        "звезды",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%B8%D0%BD%D1%8C%20%D0%B8%20%D1%8F%D0%BD%D1%8C.mp4?alt=media&token=9c190cd2-719b-43d3-b99c-2d7ed5117fd7",
        "инь и янь",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BA%D0%BE%D1%81%D1%82%D0%B5%D1%80-1.mp4?alt=media&token=803bab0e-7f5f-4515-9321-f8cef0aeb43d",
        "костер-1",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BA%D0%BE%D1%81%D1%82%D0%B5%D1%80-2.mp4?alt=media&token=8d3dc239-4614-495a-835b-2054a8a28582",
        "костер-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BA%D0%BE%D1%88%D0%BA%D0%B0-1.mp4?alt=media&token=f4c874e3-b4df-4d8c-8f1f-aee995ee360d",
        "кошка-1",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BA%D0%BE%D1%88%D0%BA%D0%B0-2.mp4?alt=media&token=23187d28-38b4-489a-b6f3-d46863aba61c",
        "кошка-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BA%D1%80%D0%B0%D1%81%D0%BA%D0%B0.mp4?alt=media&token=599343fa-2315-43cd-b5a4-c687031193bd",
        "краска",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BB%D0%B8%D1%81%D1%82%D1%8C%D1%8F-1.mp4?alt=media&token=29dec19f-559d-416b-9451-63c164baa895",
        "листья-1",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BB%D1%83%D0%BD%D0%B0.mp4?alt=media&token=f8ef8b87-21bc-4d20-922a-a1ea482f3ace",
        "луна",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BC%D0%B0%D1%82%D1%80%D0%B8%D1%86%D0%B0.mp4?alt=media&token=c5f883e2-e84c-465c-80e6-a674230aa9ac",
        "матрица",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BC%D0%B5%D0%B4%D1%83%D0%B7%D1%8B.mp4?alt=media&token=c5761245-2db6-4f64-a21b-169b451d7e92",
        "медузы",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BC%D0%B5%D0%BB%D1%8C.mp4?alt=media&token=282adeed-7686-4baa-9e64-491dbdd7aa13",
        "мель",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BC%D0%BE%D1%80%D0%B5-1.mp4?alt=media&token=1782523d-7546-43fc-b6b0-89acabb685bd",
        "море-1",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BC%D0%BE%D1%80%D0%B5-2.mp4?alt=media&token=c8ffc230-40c6-4bb3-8ecb-121ac0687a9d",
        "море-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D0%B0-1.mp4?alt=media&token=8d04190b-6b39-4758-9364-c1b252d9e58c",
        "ошибка-1",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D0%B0-2.mp4?alt=media&token=3c2dc596-67a9-46f0-b926-ca6dd9ded9ce",
        "ошибка-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D0%BF%D1%82%D0%B8%D1%86%D1%8B.mp4?alt=media&token=0564ce52-a167-4462-a41a-2687eaa2218c",
        "птицы",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D1%80%D1%83%D1%87%D0%B5%D0%B9.mp4?alt=media&token=2c628b56-9ce8-4ebb-8d56-59c0def454d3",
        "ручей",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D1%80%D1%8B%D0%B1%D0%B0.mp4?alt=media&token=4aaf39ec-f4a9-4fb1-943c-4efcabaae7aa",
        "рыба",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/%D1%87%D0%B5%D1%80%D0%BD%D1%8B%D0%B5-%D0%B2%D0%BE%D0%BB%D0%BD%D1%8B.mp4?alt=media&token=96935ecd-98b5-4cb9-b4b0-a212ee17a7bd",
        "черные-волны",
        false),
  ];
  List<Wallpaper> staticWallpapersUrlList = [
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2Fiphone.jpg?alt=media&token=7c00fe79-0a6c-421d-a263-dce37dd2efc2",
        "iphone",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B1%D0%B0%D0%BA%D1%81%D1%8B.jpg?alt=media&token=c36d4727-31b0-4230-a0c4-69d5b0fb6ba3",
        "баксы",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B4%D0%BE%D1%80%D0%BE%D0%B3%D0%B0-2.jpg?alt=media&token=9f847a26-8c35-474e-b4e2-9de6c36f23a2",
        "дорога-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B4%D0%BE%D1%80%D0%BE%D0%B3%D0%B0-3.jpg?alt=media&token=91a4b9f7-028e-4c5b-8f7f-cd7b8d6a3752",
        "дорога-3",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B4%D0%BE%D1%80%D0%BE%D0%B3%D0%B0-4.jpg?alt=media&token=80e20825-f96e-4a92-9066-a9a25a2bce1b",
        "дорога-4",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B4%D0%BE%D1%80%D0%BE%D0%B3%D0%B0-5.jpg?alt=media&token=ba914dcd-a1f3-4c4f-b037-c4b7cdfff858",
        "дорога-5",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%B4%D0%BE%D1%80%D0%BE%D0%B3%D0%B0.jpg?alt=media&token=4bb1eecb-1359-4c32-afef-529919c724e9",
        "дорога",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BA%D0%BE%D1%80%D0%BE%D0%B2%D0%B0.jpg?alt=media&token=fd079c3c-c2f0-487f-9a7f-f73ac8a8851d",
        "корова",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BA%D0%BE%D1%82%D1%8B.jpg?alt=media&token=9d76471e-2202-47a8-a6c5-7209025f0db8",
        "коты",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BA%D0%BE%D1%82%D1%8F%D1%82%D0%B0.jpg?alt=media&token=84722e2a-982d-459f-9faa-194a485ccd00",
        "котята",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BB%D0%BE%D0%B3%D0%BE%D1%82%D0%B8%D0%BF%D1%8B.jpg?alt=media&token=9b638ee2-0783-4bef-9aeb-09ae62bad75b",
        "логотипы",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BC%D0%B0%D1%88%D0%B8%D0%BD%D0%B0.jpg?alt=media&token=795579eb-9c4f-4420-b3cb-18be8f4fba6a",
        "машина",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%B1%D0%BB%D0%B0%D0%BA%D0%B0.jpg?alt=media&token=0324d67a-1e82-44c3-8864-ba3500a70d9d",
        "облака",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%B1%D0%BB%D0%B0%D0%BA%D0%BE.jpg?alt=media&token=7d0e1c43-cda1-4e9e-b245-525224b379e7",
        "облако",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%BA%D0%B5%D0%B0%D0%BD-2.jpg?alt=media&token=1e4c7056-4546-460a-ac60-29520f9e9f87",
        "океан-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%BA%D0%B5%D0%B0%D0%BD-3.jpg?alt=media&token=1b49b767-10ad-4f66-89e7-654467073b05",
        "океан-3",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%BA%D0%B5%D0%B0%D0%BD-4.jpg?alt=media&token=887d723e-bd6c-4e24-994e-bf5b3e8f7aa3",
        "океан-4",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BE%D0%BA%D0%B5%D0%B0%D0%BD.jpg?alt=media&token=f2cd1d02-6e0f-4e2a-b386-5e6e32a59448",
        "океан",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D0%BF%D0%BB%D0%B0%D0%BD%D0%B5%D1%82%D0%B0.jpg?alt=media&token=161b42a3-83f0-4f6c-996b-bde3a2bad746",
        "планета",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D1%86%D0%B2%D0%B5%D1%82%D1%8B-2.jpg?alt=media&token=a68b6ef5-41dc-4416-9d25-3e7dcb3cce4d",
        "цветы-2",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D1%86%D0%B2%D0%B5%D1%82%D1%8B-3.jpg?alt=media&token=1500842f-6265-4742-9a39-5915e0167cf2",
        "цветы-3",
        false),
    Wallpaper(
        "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/static%20wallpaper%2F%D1%86%D0%B2%D0%B5%D1%82%D1%8B.jpg?alt=media&token=614c4de2-7cfa-4779-95d4-b675fcd66d77",
        "цветы",
        false),
  ];
  String? selectedUrl;

  @override
  void initState() {
    super.initState();
  }

  Future saveSelectedVideoWallpapers(
      UserAppSettingsModel appSettings, String selectedWallpapersName) async {
    appSettings = appSettings.copyWith(
        selectedVideoWallpapersName: selectedWallpapersName);
    await ref
        .read(userAppSettingsController.notifier)
        .saveUserAppSettings(appSettings);
    log("настройки приложения сохранены с новой url -> ${appSettings.selectedVideoWallpapersName}");
  }

  @override
  Widget build(BuildContext context) {
    final appSettingsState = ref.watch(userAppSettingsController);
    final wallpapersState = ref.watch(videoWallpaperManagerProvider);

    selectedUrl ??= wallpapersState.linkToCurrentWallpaper;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  value:
                      appSettingsState.appTheme == UserAppThemeType.lightTheme
                          ? false
                          : true,
                  onChanged: (value) async {
                    var newAppSettings = appSettingsState.copyWith(
                        appTheme: value
                            ? UserAppThemeType.darkTheme
                            : UserAppThemeType.lightTheme);
                    await ref
                        .read(userAppSettingsController.notifier)
                        .saveUserAppSettings(newAppSettings);
                    setState(() {
                      Themed.clearCurrentTheme();
                      Themed.currentTheme = appSettingsState.appTheme ==
                              UserAppThemeType.lightTheme
                          ? darkTheme
                          : lightTheme;
                      //   Themed.currentTheme = anotherTheme;
                      // if (Themed.ifCurrentThemeIs(lightTheme)) {
                      //   Themed.clearCurrentTheme();
                      // } else {
                      // }
                    });
                  },
                  title: const Text("Темные плитки",
                      style: AppThemeModel.infoTextStyle),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: appSettingsState.animatedWallpapers,
                  onChanged: (value) async {
                    final newAppSettings = appSettingsState.copyWith(
                        animatedWallpapers: value, uploadedWallpapers: false);
                    await ref
                        .read(userAppSettingsController.notifier)
                        .saveUserAppSettings(newAppSettings);
                  },
                  title: const Text("Анимированные обои",
                      style: AppThemeModel.infoTextStyle),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: appSettingsState.uploadedWallpapers,
                  onChanged: (value) async {
                    final newAppSettings = appSettingsState.copyWith(
                        uploadedWallpapers: value, animatedWallpapers: false);
                    await ref
                        .read(userAppSettingsController.notifier)
                        .saveUserAppSettings(newAppSettings);
                  },
                  title: const Text("Пользовательские обои",
                      style: AppThemeModel.infoTextStyle),
                ),
                if (appSettingsState.animatedWallpapers)
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                                Container(
                                  child: const Text("Живые обои:",
                                      style: AppThemeModel.infoTextStyle),
                                ),
                              ] +
                              animatedWallpapersUrlList
                                  .map((wallpaperData) => Container(
                                        child: GestureDetector(
                                          onLongPress: () async {
                                            bool isExist = await ref
                                                .read(
                                                    videoWallpaperManagerProvider
                                                        .notifier)
                                                .checkLocalVideoExists(
                                                    wallpaperData.url);
                                            if (isExist) {
                                              _showDeleteConfirmation(
                                                  context, wallpaperData.url);
                                            }
                                          },
                                          child: ChoiceChip(
                                            selected: wallpaperData.url ==
                                                selectedUrl,
                                            label: wallpapersState.state ==
                                                        WallpapersState
                                                            .download &&
                                                    selectedUrl ==
                                                        wallpaperData.url
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "${wallpapersState.loadingProcent}%"),
                                                      const SizedBox(width: 8),
                                                      const SizedBox(
                                                          width: 12,
                                                          height: 12,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: AppThemeModel
                                                                .glassColor,
                                                          )),
                                                    ],
                                                  )
                                                : Text(
                                                    wallpaperData.name,
                                                    style: AppThemeModel
                                                        .infoTextStyle,
                                                  ),
                                            onSelected: wallpapersState.state !=
                                                        WallpapersState
                                                            .download &&
                                                    !wallpapersState
                                                        .isAnimate &&
                                                    !wallpapersState.canFadeIn
                                                ? (value) async {
                                                    selectedUrl =
                                                        wallpaperData.url;
                                                    await ref
                                                        .read(
                                                            videoWallpaperManagerProvider
                                                                .notifier)
                                                        .setVideoWallpaper(
                                                            wallpaperData.url);
                                                    await saveSelectedVideoWallpapers(
                                                        appSettingsState,
                                                        wallpaperData.url);
                                                    setState(() {});
                                                  }
                                                : null,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                if (appSettingsState.uploadedWallpapers)
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                                Container(
                                  child: const Text("Обои:",
                                      style: AppThemeModel.infoTextStyle),
                                ),
                              ] +
                              staticWallpapersUrlList
                                  .map((wallpaperData) => Container(
                                        child: GestureDetector(
                                          onLongPress: () async {
                                            bool isExist = await ref
                                                .read(
                                                    videoWallpaperManagerProvider
                                                        .notifier)
                                                .checkLocalVideoExists(
                                                    wallpaperData.url);
                                            if (isExist) {
                                              _showDeleteConfirmation(
                                                  context, wallpaperData.url);
                                            }
                                          },
                                          child: ChoiceChip(
                                            selected: wallpaperData.url ==
                                                selectedUrl,
                                            label: wallpapersState.state ==
                                                        WallpapersState
                                                            .download &&
                                                    selectedUrl ==
                                                        wallpaperData.url
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "${wallpapersState.loadingProcent}%"),
                                                      const SizedBox(width: 8),
                                                      const SizedBox(
                                                          width: 12,
                                                          height: 12,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: AppThemeModel
                                                                .glassColor,
                                                          )),
                                                    ],
                                                  )
                                                : Text(
                                                    wallpaperData.name,
                                                    style: AppThemeModel
                                                        .infoTextStyle,
                                                  ),
                                            onSelected: wallpapersState.state !=
                                                        WallpapersState
                                                            .download &&
                                                    !wallpapersState
                                                        .isAnimate &&
                                                    !wallpapersState.canFadeIn
                                                ? (value) async {
                                                    selectedUrl =
                                                        wallpaperData.url;
                                                    await ref
                                                        .read(
                                                            videoWallpaperManagerProvider
                                                                .notifier)
                                                        .downloadJPG(
                                                            wallpaperData.url);
                                                    await saveSelectedVideoWallpapers(
                                                        appSettingsState,
                                                        wallpaperData.url);
                                                    setState(() {});
                                                  }
                                                : null,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ));
  }

  void _showDeleteConfirmation(BuildContext context, String url) {
    Widget cancelButton = ElevatedButton(
      child: const Text(
        "Нет",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
      },
    );

    Widget continueButton = ElevatedButton(
      child: const Text(
        "Да",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () async {
        var appSettings = ref.read(userAppSettingsController);
        await saveSelectedVideoWallpapers(appSettings, "");
        ref
            .read(videoWallpaperManagerProvider.notifier)
            .deleteVideoWallpaper(url);

        Navigator.of(context).pop(); // Close the dialog
      },
    );

    Dialog alert = Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.6, sigmaY: 12.6),
          child: CustomPaint(
            painter: BorderPainter(borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              padding: const EdgeInsets.all(12),
              color:
                  Colors.white.withOpacity(0.2), // Translucent white background
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "Удалить эти обои с устройства?",
                      style: AppThemeModel.infoTextStyle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cancelButton,
                      continueButton,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
