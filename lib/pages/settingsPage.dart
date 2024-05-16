import 'dart:developer';
import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/controllers/videoWallpaperManagerProvider.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/routes/router.dart';
import 'package:timebalance/widgets/glassContainer.dart';
import 'package:timebalance/widgets/pomodoroUpCounter.dart';
import 'package:timebalance/widgets/resetStepButton.dart';
import 'package:timebalance/widgets/selectSchemeButton.dart';
import 'package:timebalance/widgets/skipButton.dart';
import 'package:timebalance/widgets/videoWallpaperWidget.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final videoWallpaperState = ref.watch(videoWallpaperManagerProvider);
    final appSettingsState = ref.watch(userAppSettingsController);

    Color backgroundColor =
        AppThemeModel.glassColor.withOpacity(0.21); // Прозрачность фона
    double blurStrength = 12.6; // Сила размытия

    return AutoTabsRouter(
      routes: const [
        AnalyticsSettingsRoute(),
        TimerSettingsRoute(),
        AppSettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return VideoWallpaperWidget(
          key: ValueKey(
              "VideoWallpaperWidget - ${appSettingsState.animatedWallpapers}/${appSettingsState.uploadedWallpapers}"),
          child: Scaffold(
            appBar: AppBar(
              leading: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                      onPressed: () {
                        AutoRouter.of(context).pushNamed("/main");
                      },
                      icon: const Icon(
                        Icons.arrow_back,
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
            backgroundColor: Colors.transparent,
            body: child,
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ), // Закругление верхних углов
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurStrength, sigmaY: blurStrength),
                child: BottomNavigationBar(
                  selectedFontSize: 16,
                  unselectedFontSize: 16,
                  backgroundColor: backgroundColor,
                  currentIndex: tabsRouter.activeIndex,
                  onTap: (value) {
                    tabsRouter.setActiveIndex(value);
                  },
                  selectedItemColor:
                      AppThemeModel.mainInfoColor, // Цвет выбранной вкладки
                  unselectedItemColor: AppThemeModel.mainInfoColor
                      .withOpacity(0.21), // Цвет невыбранной вкладки
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.bar_chart,
                          size: 0,
                        ),
                        label: "Аналитика"),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.timer,
                          size: 0,
                        ),
                        label: "Таймер"),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.apps,
                          size: 0,
                        ),
                        label: "Приложение"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
