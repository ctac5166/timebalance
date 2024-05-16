import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/schemeControllerProvider.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/objectbox.g.dart';
import 'package:timebalance/widgets/centerTimerBlock.dart';
import 'package:timebalance/widgets/editableTextWidget.dart';
import 'package:timebalance/widgets/glassContainer.dart';
import 'package:timebalance/widgets/glassNumberPickerDialog.dart';

@RoutePage()
class TimerSettingsPage extends ConsumerStatefulWidget {
  const TimerSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerSettingsPageState();
}

class _TimerSettingsPageState extends ConsumerState<TimerSettingsPage> {
  bool schemesInited = false;
  bool schemesSaving = false;

  Future loadSchemes() async {
    if (!schemesInited) {
      await ref.read(schemeControllerProvider.notifier).loadAllSchemes();
      final schemeControllerState = ref.read(schemeControllerProvider);
      ref
          .read(timerControllerProvider.notifier)
          .updateSchemes(schemeControllerState);
      setState(() {
        schemesInited = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final schemeControllerState = ref.watch(schemeControllerProvider);
    final timerControllerState = ref.watch(timerControllerProvider);
    final timerController = ref.watch(timerControllerProvider.notifier);

    // Убедимся, что загрузка схем происходит только один раз при инициализации виджета
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!schemesInited) {
        await loadSchemes();
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Wrap(
                    key: ValueKey(
                        "schemes-wraper-${schemeControllerState.length}"),
                    spacing: 8,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                          Container(
                            child: const Text("Схемы:",
                                style: AppThemeModel.infoTextStyle),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!schemesSaving) {
                                setState(() {
                                  schemesSaving = true;
                                });
                                await ref
                                    .read(schemeControllerProvider.notifier)
                                    .createNewScheme();
                                schemesInited = false;
                                await loadSchemes();
                                setState(() {
                                  schemesSaving = false;
                                });
                                await loadSchemes();
                              }
                            },
                            child: const GlassContainer(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.add)),
                          )
                        ] +
                        schemeControllerState.map((shemeData) {
                          bool isSelected = shemeData.shemeName ==
                              timerController.getCurrentScheme().shemeName;
                          return Container(
                            child: GestureDetector(
                              onLongPress: () async {
                                _showDeleteConfirmation(
                                    context, shemeData.shemeName);
                              },
                              child: ChoiceChip(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 8, top: 8, bottom: 8),
                                showCheckmark: false,
                                iconTheme: const IconThemeData(
                                    color: AppThemeModel.glassSecondColor),
                                backgroundColor: schemesSaving
                                    ? AppThemeModel.glassSecondColor
                                    : AppThemeModel.glassColor,
                                selected: isSelected,
                                label: schemesSaving
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected)
                                            const Icon(
                                              Icons.done,
                                              size: 20,
                                            ),
                                          if (isSelected)
                                            const SizedBox(width: 8),
                                          Text(
                                            shemeData.shemeName,
                                            style: isSelected
                                                ? AppThemeModel.chipTextStyle
                                                : AppThemeModel.infoTextStyle,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected)
                                            const Icon(
                                              Icons.done,
                                              size: 20,
                                              color:
                                                  AppThemeModel.chipTextColor,
                                            ),
                                          if (isSelected)
                                            const SizedBox(width: 8),
                                          EditableTextWidget(
                                            textStyle: shemeData.shemeName ==
                                                    timerController
                                                        .getCurrentScheme()
                                                        .shemeName
                                                ? AppThemeModel.chipTextStyle
                                                : AppThemeModel.infoTextStyle,
                                            key: ValueKey(
                                                "${shemeData.shemeName}-${shemeData.shemeName == timerControllerState.dayStatistics.shemeName}"),
                                            onTextChanged: (value) async {
                                              if (!schemesSaving) {
                                                setState(() {
                                                  schemesSaving = true;
                                                });
                                                if (value != "" &&
                                                    schemeControllerState
                                                            .indexWhere((element) =>
                                                                element
                                                                    .shemeName ==
                                                                value) ==
                                                        -1) {
                                                  var newShemeData =
                                                      shemeData.copyWith(
                                                          shemeName: value);

                                                  await ref
                                                      .read(
                                                          schemeControllerProvider
                                                              .notifier)
                                                      .updateScheme(
                                                          newShemeData,
                                                          shemeData.shemeName);
                                                  logger.d(
                                                      "новое название схемы - $value");
                                                  ref
                                                      .read(
                                                          timerControllerProvider
                                                              .notifier)
                                                      .updateSchemes(ref.read(
                                                          schemeControllerProvider));
                                                  await ref
                                                      .read(
                                                          timerControllerProvider
                                                              .notifier)
                                                      .changeSheme(value);
                                                  logger.d(
                                                      "${ref.read(timerControllerProvider.notifier).getCurrentScheme().shemeName} - новая схема применена");
                                                }
                                                schemesInited = false;
                                                schemesSaving = false;
                                                setState(() {});
                                              }
                                            },
                                            initialText: shemeData.shemeName,
                                          ),
                                        ],
                                      ),
                                onSelected: (value) async {
                                  if (!schemesSaving) {
                                    await ref
                                        .read(timerControllerProvider.notifier)
                                        .changeSheme(shemeData.shemeName);
                                    logger.d(
                                        "схема заменена на ${shemeData.shemeName}");
                                    schemesInited = false;
                                    setState(() {});
                                  } else {
                                    logger.w(
                                        "сейчас происходит сохранение состояния");
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!ref.watch(schemeControllerProvider.notifier).isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${timerController.getCurrentScheme().shemeName.characters.take(20)}...",
                      style: AppThemeModel.infoTextStyle,
                    ),
                    Text(
                      "${formatMinutes(timerController.getCurrentScheme().workSessionTimeInSeconds)} • ${formatMinutes(timerController.getCurrentScheme().shortBreakTimeInSeconds)} • ${formatMinutes(timerController.getCurrentScheme().breakTimeInSeconds)} • ${timerController.getCurrentScheme().numberOfSessionsBeforeLongBreak}",
                      style: AppThemeModel.infoTextStyle,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (!ref.watch(schemeControllerProvider.notifier).isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  key: ValueKey(
                      "Длит. Помидора - ${timerController.getCurrentScheme()}"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "🔥 Продолжительность помидора",
                        style: AppThemeModel.infoTextStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!["обычный", "длинный", "короткий", "DEBUG"]
                            .contains(
                                timerController.getCurrentScheme().shemeName)) {
                          return _showNumberPickerDialog(context,
                              (value) async {
                            var newSchemeParams = timerController
                                .getCurrentScheme()
                                .copyWith(workSessionTimeInSeconds: value * 60);

                            logger.i(
                                "попытка обновить ${newSchemeParams.shemeName}");
                            await ref
                                .read(schemeControllerProvider.notifier)
                                .updateScheme(
                                    newSchemeParams, newSchemeParams.shemeName);
                            schemesInited = false;
                            await loadSchemes();
                            setState(() {
                              logger.d(
                                  "параметры схемы обновлены - $newSchemeParams");
                            });
                          },
                              timerController
                                      .getCurrentScheme()
                                      .workSessionTimeInSeconds ~/
                                  60);
                        } else {
                          null;
                        }
                      },
                      child: GlassContainer(
                        child: Text(
                          //timerController.getCurrentScheme().shemeName
                          formatDurationToHMS(timerController
                              .getCurrentScheme()
                              .workSessionTimeInSeconds),
                          style: AppThemeModel.infoTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (!ref.watch(schemeControllerProvider.notifier).isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  key: ValueKey(
                      "Продолжительность короткого перерыва - ${timerController.getCurrentScheme()}"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "☕ Продолжительность короткого перерыва",
                        style: AppThemeModel.infoTextStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!["обычный", "длинный", "короткий", "DEBUG"]
                            .contains(
                                timerController.getCurrentScheme().shemeName)) {
                          return _showNumberPickerDialog(context,
                              (value) async {
                            var newSchemeParams = timerController
                                .getCurrentScheme()
                                .copyWith(shortBreakTimeInSeconds: value * 60);

                            logger.i(
                                "попытка обновить ${newSchemeParams.shemeName}");
                            await ref
                                .read(schemeControllerProvider.notifier)
                                .updateScheme(
                                    newSchemeParams, newSchemeParams.shemeName);
                            schemesInited = false;
                            await loadSchemes();
                            setState(() {
                              logger.d(
                                  "параметры схемы обновлены - $newSchemeParams");
                            });
                          },
                              timerController
                                      .getCurrentScheme()
                                      .shortBreakTimeInSeconds ~/
                                  60);
                        } else {
                          null;
                        }
                      },
                      child: GlassContainer(
                        child: Text(
                          //timerController.getCurrentScheme().shemeName
                          formatDurationToHMS(timerController
                              .getCurrentScheme()
                              .shortBreakTimeInSeconds),
                          style: AppThemeModel.infoTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (!ref.watch(schemeControllerProvider.notifier).isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  key: ValueKey(
                      "Продолжительность длинного перерыва - ${timerController.getCurrentScheme()}"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "🚬 Продолжительность длинного перерыва",
                        style: AppThemeModel.infoTextStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!["обычный", "длинный", "короткий", "DEBUG"]
                            .contains(
                                timerController.getCurrentScheme().shemeName)) {
                          return _showNumberPickerDialog(context,
                              (value) async {
                            var newSchemeParams = timerController
                                .getCurrentScheme()
                                .copyWith(breakTimeInSeconds: value * 60);

                            logger.i(
                                "попытка обновить ${newSchemeParams.shemeName}");
                            await ref
                                .read(schemeControllerProvider.notifier)
                                .updateScheme(
                                    newSchemeParams, newSchemeParams.shemeName);
                            schemesInited = false;
                            await loadSchemes();
                            setState(() {
                              logger.d(
                                  "параметры схемы обновлены - $newSchemeParams");
                            });
                          },
                              timerController
                                      .getCurrentScheme()
                                      .breakTimeInSeconds ~/
                                  60);
                        } else {
                          null;
                        }
                      },
                      child: GlassContainer(
                        child: Text(
                          //timerController.getCurrentScheme().shemeName
                          formatDurationToHMS(timerController
                              .getCurrentScheme()
                              .breakTimeInSeconds),
                          style: AppThemeModel.infoTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (!ref.watch(schemeControllerProvider.notifier).isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  key: ValueKey(
                      "Длинный перерыв каждые (в помидорах) - ${timerController.getCurrentScheme()}"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "⌛ Длинный перерыв каждые (в помидорах)",
                        style: AppThemeModel.infoTextStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!["обычный", "длинный", "короткий", "DEBUG"]
                            .contains(
                                timerController.getCurrentScheme().shemeName)) {
                          return _showCountPickerDialog(context, (value) async {
                            var newSchemeParams = timerController
                                .getCurrentScheme()
                                .copyWith(
                                    numberOfSessionsBeforeLongBreak: value);

                            logger.i(
                                "попытка обновить ${newSchemeParams.shemeName}");
                            await ref
                                .read(schemeControllerProvider.notifier)
                                .updateScheme(
                                    newSchemeParams, newSchemeParams.shemeName);
                            schemesInited = false;
                            await loadSchemes();
                            setState(
                              () {
                                logger.d(
                                    "параметры схемы обновлены - $newSchemeParams");
                              },
                            );
                          },
                              timerController
                                  .getCurrentScheme()
                                  .numberOfSessionsBeforeLongBreak);
                        } else {
                          null;
                        }
                      },
                      child: GlassContainer(
                        child: Text(
                          //timerController.getCurrentScheme().shemeName
                          "${timerController.getCurrentScheme().numberOfSessionsBeforeLongBreak} шт",
                          style: AppThemeModel.infoTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String formatMinutes(int seconds) {
    int minutes = (seconds ~/ 60);

    return "$minutes";
  }

  String formatDurationToHMS(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = 0;

    String formattedHours = hours > 0 ? "$hours ч " : "";
    String formattedMinutes = minutes > 0 ? "$minutes мин " : "";
    String formattedSeconds = secs > 0 ? "$secs сек" : "";

    return "$formattedHours$formattedMinutes$formattedSeconds".trim();
  }

  void _showNumberPickerDialog(
      BuildContext context, Function(int) onValueSelected, int initialValue) {
    showDialog(
      context: context,
      builder: (context) => GlassNumberPickerDialog(
        initialValue: initialValue,
        minValue: 5,
        maxValue: 240,
        onValueSelected: onValueSelected,
      ),
    );
  }

  void _showCountPickerDialog(
      BuildContext context, Function(int) onValueSelected, int initialValue) {
    showDialog(
      context: context,
      builder: (context) => GlassNumberPickerDialog(
        initialValue: initialValue,
        onValueSelected: onValueSelected,
        minValue: 2,
        maxValue: 8,
        prefixName: "Выберите кол-во",
        variableName: "шт",
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String schemeName) {
    final timerControllerState = ref.read(timerControllerProvider);

    Widget cancelButton = ElevatedButton(
      child: const Text(
        "Нет",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = ElevatedButton(
      child: const Text(
        "Да",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () async {
        await ref
            .read(schemeControllerProvider.notifier)
            .deleteScheme(schemeName);
        await loadSchemes();
        if (timerControllerState.dayStatistics.shemeName == schemeName) {
          await ref
              .read(timerControllerProvider.notifier)
              .changeSheme("обычный");
        }
        Navigator.of(context).pop();
        setState(() {});
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              color:
                  Colors.white.withOpacity(0.2), // Translucent white background
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Удалить схему таймера?",
                        style: AppThemeModel.infoTextStyle),
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
