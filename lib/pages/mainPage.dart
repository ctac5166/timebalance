import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/controllers/schemeControllerProvider.dart';
// import 'package:timebalance/controllers/notificationControllerProvider.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/controllers/videoWallpaperManagerProvider.dart';
import 'package:timebalance/data/models/timerStateModel.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/animatedTimeText.dart';
import 'package:timebalance/widgets/centerTimerBlock.dart';
import 'package:timebalance/widgets/glassContainer.dart';
import 'package:timebalance/widgets/pomodoroUpCounter.dart';
import 'package:timebalance/widgets/popupChoiceMenu.dart';
import 'package:timebalance/widgets/resetStepButton.dart';
import 'package:timebalance/widgets/selectSchemeButton.dart';
import 'package:timebalance/widgets/skipButton.dart';
import 'package:timebalance/widgets/videoWallpaperWidget.dart';

@RoutePage()
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  Color backgroundColor =
      AppThemeModel.glassColor.withOpacity(0.21); // Прозрачность фона
  double blurStrength = 12.6; // Сила размытия
  bool _wallpapersInited = false;

  @override
  void initState() {
    super.initState();
    if (!_wallpapersInited) initSelectedWallpapers();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userAppSettingsController.notifier).initObjectBox();
      final appSettings = ref.read(userAppSettingsController);
      if (appSettings.needGuide &&
          ref.read(userAppSettingsController.notifier).isSettingsLoaded) {
        AutoRouter.of(context).pushNamed("/guide");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatTime(int? seconds, bool pad) {
    return (pad)
        ? "${(seconds! / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
        : (seconds! > 59)
            ? "${(seconds / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
            : seconds.toString();
  }

  Future initSelectedWallpapers() async {
    _wallpapersInited = true;
    await ref.read(userAppSettingsController.notifier).initObjectBox();
    final appSettingsState = ref.read(userAppSettingsController);
    final videoPlayerState = ref.read(videoWallpaperManagerProvider);
    log("попытка инициализировать обои -> ${appSettingsState.animatedWallpapers}=appSettingsState.animatedWallpapers,\n ${appSettingsState.selectedVideoWallpapersName}=appSettingsState.selectedVideoWallpapersName");
    if ((appSettingsState.animatedWallpapers ||
            appSettingsState.uploadedWallpapers) &&
        (appSettingsState.selectedVideoWallpapersName != "" &&
            videoPlayerState.fullPathToCurrentWallpapers == "") &&
        videoPlayerState.state != WallpapersState.download &&
        !videoPlayerState.isAnimate) {
      if (appSettingsState.animatedWallpapers) {
        logger.d("попытка инициализировать видео обои");
        await ref
            .read(videoWallpaperManagerProvider.notifier)
            .setVideoWallpaper(appSettingsState.selectedVideoWallpapersName);
        setState(() {});
      } else {
        logger.d("попытка инициализировать статичные обои");
        await ref
            .read(videoWallpaperManagerProvider.notifier)
            .downloadJPG(appSettingsState.selectedVideoWallpapersName);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.read(timerControllerProvider);
    final appSettings = ref.watch(userAppSettingsController);
    final videoPlayerState = ref.watch(videoWallpaperManagerProvider);

    return VideoWallpaperWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Row(
            children: [
              const SizedBox(width: 4),
              IconButton(
                  onPressed: () {
                    AutoRouter.of(context).pushNamed("/settings/timer");
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: AppThemeModel.mainInfoColor,
                  ))
            ],
          ),
          actions: const [
            SelectSchemeButton(),
            ResetStepButton(),
            SizedBox(width: 4),
            PomodoroUpCounter(),
            SizedBox(width: 4),
            SkipButton(),
            SizedBox(width: 4),
          ],
          backgroundColor: Colors.transparent,
          // title: const Text('Main Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const CenterTimerBlock(),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: GlassContainer(
                  mode: ContainerMode.fillHorizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          timerState.dayStatistics
                                          .totalWorkTimeForTheEntireInterval <
                                      20 ||
                                  timerState.dayStatistics
                                          .maximumWorkTimeDuringThisInterval <
                                      20
                              ? "Ваш уровень концентрации формируется во время работы"
                              : "Уровень Концентрации ${((timerState.dayStatistics.totalWorkTimeForTheEntireInterval / timerState.dayStatistics.maximumWorkTimeDuringThisInterval) * 100).round()}%",
                          style: const TextStyle(
                              color: AppThemeModel.mainInfoColor),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                          onPressed: () {
                            AutoRouter.of(context)
                                .pushNamed("/settings/analytics");
                          },
                          icon: const Icon(
                            Icons.query_stats_rounded,
                            color: AppThemeModel.mainInfoColor,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ), // Закругление верхних углов
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
            child: BottomNavigationBar(
              onTap: (index) {
                switch (index) {
                  case 0:
                    timerState.currentState == StepType.pause ||
                            timerState.currentState ==
                                StepType.delayBeforeLongBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeShortBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeWork ||
                            timerState.currentState ==
                                StepType.longDelayBeforeWork
                        ? ref
                            .read(timerControllerProvider.notifier)
                            .stopTimer(completeStop: true)
                        : ref
                            .read(timerControllerProvider.notifier)
                            .pauseTimer();
                    break;
                  case 1:
                    // ref
                    //     .read(notificationProvider.notifier)
                    //     .createPinnedNotification();
                    ref
                        .read(timerControllerProvider.notifier)
                        .startTimer(userInput: true);
                    break;
                }
              },
              selectedFontSize: 16,
              unselectedFontSize: 16,
              backgroundColor: backgroundColor,
              selectedItemColor:
                  AppThemeModel.mainInfoColor, // Цвет выбранной вкладки
              unselectedItemColor:
                  AppThemeModel.mainInfoColor, // Цвет невыбранной вкладки
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(
                      Icons.stop,
                      size: 0,
                    ),
                    label: timerState.currentState == StepType.pause ||
                            timerState.currentState ==
                                StepType.delayBeforeLongBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeShortBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeWork ||
                            timerState.currentState ==
                                StepType.longDelayBeforeWork
                        ? "Стоп"
                        : timerState.currentState == StepType.off
                            ? ""
                            : "Пауза"),
                BottomNavigationBarItem(
                    icon: const Icon(
                      Icons.start,
                      size: 0,
                    ),
                    label: timerState.currentState ==
                                StepType.delayBeforeLongBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeShortBreak ||
                            timerState.currentState ==
                                StepType.delayBeforeWork ||
                            timerState.currentState ==
                                StepType.longDelayBeforeWork ||
                            timerState.currentState == StepType.pause
                        ? "Продолжить"
                        : timerState.currentState == StepType.off
                            ? "Старт"
                            : ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
