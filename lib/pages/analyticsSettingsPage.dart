import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timebalance/data/models/dayStatsModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/objectbox.g.dart';
import 'package:timebalance/widgets/glassContainer.dart';
import 'package:timebalance/widgets/statsChartWidget.dart';

@RoutePage()
class AnalyticsSettingsPage extends ConsumerStatefulWidget {
  const AnalyticsSettingsPage({super.key});

  @override
  ConsumerState<AnalyticsSettingsPage> createState() =>
      _AnalyticsSettingsPageState();
}

class _AnalyticsSettingsPageState extends ConsumerState<AnalyticsSettingsPage> {
  bool dataInited = false;
  double medianMin = 0;
  double medianConcentration = 0;
  double timeToday = 0;
  double totalEfficiency = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    if (!dataInited) {
      calculateMedians();
    }
  }

  String formatDuration(int totalSeconds) {
    if (totalSeconds == 0) {
      return "...";
    }
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    String formatted = "";
    if (hours > 0) {
      formatted += "$hoursч ";
    }
    if (minutes > 0 || hours > 0) {
      formatted += "$minutesмин";
    }
    return formatted.trim();
  }

  void deleteDataAlertDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: const Text(
        "Отмена",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text(
        "Удалить данные!",
        style: AppThemeModel.infoTextStyle,
      ),
      onPressed: () async {
        final store = objectbox.store;
        final box = store.box<DayStatsEntity>();
        await box.removeAllAsync();
        logger.w("все данные о концентрации удалены");

        setState(() {
          Navigator.of(context).pop();
        });
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
                    child: Text("Предупреждение!",
                        style: AppThemeModel.infoTextStyle),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Вы точно хотите удалить все данные?",
                        style: AppThemeModel.infoTextStyle),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      continueButton,
                      cancelButton,
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

  Future calculateMedians() async {
    var daysData = await getDayStatsEntity();
    double totalWorkTime = 0;
    for (var dayData in daysData) {
      medianMin += dayData.totalWorkTimeForTheEntireInterval;
      totalWorkTime += dayData.totalWorkTimeForTheEntireInterval;
      if (dayData.totalWorkTimeForTheEntireInterval > 0 &&
          dayData.maximumWorkTimeDuringThisInterval > 0) {
        medianConcentration += (dayData.totalWorkTimeForTheEntireInterval /
                dayData.maximumWorkTimeDuringThisInterval)
            .toDouble();
      }
    }
    if (daysData.isNotEmpty) {
      medianMin /= daysData.length;
      medianConcentration /= daysData.length.toDouble();
    }
    double totalHours = totalWorkTime / 3600;
    totalEfficiency = (totalHours / 24.5) * medianConcentration;
    logger.d(
        "Общее время работы: $totalHours часов, Общая эффективность: $totalEfficiency%");
    timeToday = daysData.isNotEmpty
        ? daysData.last.totalWorkTimeForTheEntireInterval.toDouble()
        : 0;
    dataInited = true;

    setState(() {});
  }

  Future<List<DayStatsEntity>> getDayStatsEntity() async {
    final store = objectbox.store;
    final box = store.box<DayStatsEntity>();
    final query = box
        .query(DayStatsEntity_.statsDate.greaterOrEqual(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(const Duration(days: 6))
            .millisecondsSinceEpoch))
        .build();
    log("|🔍|-> AnalyticsSettingsPage найдено DayStatsEntity: ${query.find().length}");
    final result = await query.findAsync();
    query.close();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Статистика работы за - ${DateFormat('MMMM', 'ru_RU').format(DateTime.now())} (${DateTime.now().subtract(const Duration(days: 6)).day}-${DateTime.now().day})",
                  style: AppThemeModel.infoTextStyle,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                      height: constraints.maxHeight / 2.5,
                      width: constraints.maxWidth,
                      child: const StatsChartWidget()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    child: Container(
                      child: GlassContainer(
                          mode: ContainerMode.fillHorizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Время за сегодня",
                                style: AppThemeModel.infoTextStyle,
                              ),
                              Text(
                                timeToday == 0
                                    ? "..."
                                    : formatDuration(timeToday.toInt()),
                                style: AppThemeModel.infoTextStyle,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    child: Container(
                      child: GlassContainer(
                          mode: ContainerMode.fillHorizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Медиана (день)",
                                style: AppThemeModel.infoTextStyle,
                              ),
                              Text(
                                formatDuration(medianMin.toInt()),
                                style: AppThemeModel.infoTextStyle,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    child: Container(
                      child: GlassContainer(
                          mode: ContainerMode.fillHorizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Медиана концентрации",
                                style: AppThemeModel.infoTextStyle,
                              ),
                              Text(
                                medianConcentration == 0
                                    ? "..."
                                    : "${(medianConcentration * 100).toInt()}%",
                                style: AppThemeModel.infoTextStyle,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Ink(
                    child: Container(
                      child: GlassContainer(
                          mode: ContainerMode.fillHorizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ваша эффективность! ",
                                style: AppThemeModel.infoTextStyle,
                              ),
                              Text(
                                totalEfficiency == 0
                                    ? "..."
                                    : "${(totalEfficiency * 100).toInt()}%",
                                style: AppThemeModel.infoTextStyle,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: SizedBox(
                    width: constraints.maxWidth - 64,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Удалить данные",
                          style: AppThemeModel.infoTextStyle,
                        ),
                        Icon(
                          Icons.delete,
                          color: AppThemeModel.mainInfoColor,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    deleteDataAlertDialog(context);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
