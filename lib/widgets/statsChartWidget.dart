import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timebalance/data/models/dayStatsModel.dart';
import 'package:timebalance/main.dart';

import 'dart:math' as math;

import 'package:timebalance/objectbox.g.dart';

class StatsChartWidget extends ConsumerStatefulWidget {
  const StatsChartWidget({super.key});

  @override
  _StatsChartWidgetState createState() => _StatsChartWidgetState();
}

class _StatsChartWidgetState extends ConsumerState<StatsChartWidget> {
  Map<DateTime, double> _dailyConcentration = {};
  final Map<DateTime, double> _averageConcentration = {};

  bool dataInited = false;

  @override
  void initState() {
    super.initState();
    if (!dataInited) initializeDateFormatting();
    if (!dataInited && !kReleaseMode) fillRandomDataIfNecessary();
    if (!dataInited) _analyzeDayStats();
    if (!dataInited) _loadStats();
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
    log("|🔍|-> StatsChartWidget найдено DayStatsEntity: ${query.find().length}");
    final result = await query.findAsync();
    query.close();
    return result;
  }

  void fillRandomDataIfNecessary() {
    final store = objectbox.store;
    final box = store.box<DayStatsEntity>();
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final schemeNames = ['обычный', 'короткий', 'длинный'];

    if (box.count() < 30) {
      final random = math.Random();
      for (int i = 0; i < 30; i++) {
        final statsDate = today.subtract(Duration(days: i));
        final schemeName = schemeNames[random.nextInt(schemeNames.length)];
        final maximumWorkTimeDuringThisInterval =
            random.nextInt((60 * 60 * 3.5).toInt()) + (60 * 60);
        final totalWorkTimeForTheEntireInterval =
            random.nextInt(maximumWorkTimeDuringThisInterval) + 10 * 60;

        DayStatsEntity newEntry = DayStatsEntity(
            shemeName: schemeName,
            statsDate: statsDate,
            maximumWorkTimeDuringThisInterval:
                maximumWorkTimeDuringThisInterval,
            totalWorkTimeForTheEntireInterval:
                totalWorkTimeForTheEntireInterval);

        box.put(newEntry);
      }
      log("|💾🔍|-> Added 30 new random DayStatsEntities.");
    } else {
      log("|💾🔍|-> No need to add random data. Current entries: ${box.count()}");
    }
  }

  Future _analyzeDayStats() async {
    final store = objectbox.store;
    final box = store.box<DayStatsEntity>();
    final stats = await getDayStatsEntity();

    final Map<DateTime, List<DayStatsEntity>> groupedStats = {};
    for (var stat in stats) {
      DateTime dateOnly = DateTime(
          stat.statsDate.year, stat.statsDate.month, stat.statsDate.day);
      if (!groupedStats.containsKey(dateOnly)) {
        groupedStats[dateOnly] = [];
      }
      groupedStats[dateOnly]!.add(stat);
    }

    groupedStats.forEach((date, list) {
      list.sort((a, b) =>
          a.concentrationPercentage.compareTo(b.concentrationPercentage));
      double medianConcentration =
          findMedian(list.map((e) => e.concentrationPercentage).toList());

      int totalWorkTime = list.fold(
          0, (sum, current) => sum + current.totalWorkTimeForTheEntireInterval);

      double total = 0;
      for (var item in list) {
        total += item.concentrationPercentage;
      }

      double avg = total / list.length;
      _averageConcentration[date] = avg;

      log("|💾🔍|-> Date: $date");
      log("|💾🔍|-> Median Concentration Percentage: $medianConcentration%");
      log("|💾🔍|-> Total Work Time for the Entire Interval: ${totalWorkTime ~/ 60} minutes");
      log("|💾🔍|-> ----------");
    });
  }

  double findMedian(List<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    int middle = values.length ~/ 2;
    if (values.length % 2 == 1) {
      return values[middle];
    } else {
      return (values[middle - 1] + values[middle]) / 2.0;
    }
  }

  Future _loadStats() async {
    List<DayStatsEntity> stats = await getDayStatsEntity();

    // Группировка по датам и расчет медианных значений
    Map<DateTime, List<double>> grouped = {};
    for (var stat in stats) {
      grouped
          .putIfAbsent(stat.statsDate, () => [])
          .add(stat.concentrationPercentage);
    }

    _dailyConcentration = grouped.map((date, percentages) {
      percentages.sort();
      double median = percentages.length % 2 == 1
          ? percentages[percentages.length ~/ 2]
          : (percentages[(percentages.length ~/ 2) - 1] +
                  percentages[percentages.length ~/ 2]) /
              2.0;
      log("$date = grouped.map");
      return MapEntry(date, (median).clamp(0, 100));
    });

    dataInited = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_dailyConcentration.entries.isEmpty) {
      return (const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(),
        ),
      ));
    }

    if (_dailyConcentration.entries.length < 2) {
      return (const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 28, right: 48),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      "Развивайте усидчивости. Нам нужно больше данных...",
                      style: AppThemeModel.infoTextStyle,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.timeline_rounded),
                ],
              ),
            )
          ],
        ),
      ));
    }

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
            child: LineChart(_buildChart()),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;

    text = const Text('MAR', style: AppThemeModel.infoTextStyle);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  double dateToDouble(DateTime date) {
    return date.month + date.day / 100;
  }

  DateTime doubleToDate(double dateDouble) {
    int month = dateDouble.truncate();
    int day = ((dateDouble - month) * 100).round();
    int year = DateTime.now().year; // Получаем текущий год
    return DateTime(year, month, day);
  }

  Map<String, double> getTrendPoints(Map<DateTime, double> data) {
    if (data.isEmpty) {
      return {};
    }
    List<DateTime> dates = data.keys.toList()..sort();
    List<double> xs = [];
    List<double> ys = [];
    final dateFormat = DateFormat('yyyyMMdd');
    for (var date in dates) {
      xs.add(double.parse(dateFormat.format(date)));
      ys.add(data[date] ?? 0);
    }
    double xMean = xs.reduce((a, b) => a + b) / xs.length;
    double yMean = ys.reduce((a, b) => a + b) / ys.length;
    double numerator = 0;
    double denominator = 0;
    for (int i = 0; i < xs.length; i++) {
      numerator += (xs[i] - xMean) * (ys[i] - yMean);
      denominator += (xs[i] - xMean) * (xs[i] - xMean);
    }
    double slope = numerator / denominator;
    double intercept = yMean - slope * xMean;
    double yStart = slope * xs.first + intercept;
    double yEnd = slope * xs.last + intercept;
    return {
      "yStart": yStart,
      "yEnd": yEnd,
    };
  }

  LineChartData _buildChart() {
    List<Color> gradientColors = [
      Colors.white.withOpacity(1),
      Colors.white.withOpacity(1)
    ];

    List<FlSpot> spots = _dailyConcentration.entries.map((entry) {
      log("создаю FlSpot: ${dateToDouble(entry.key)}, ${entry.value}");
      return FlSpot(
          dateToDouble(entry.key), ((entry.value).toInt()).toDouble());
    }).toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    List<FlSpot> averageSpots = [];
    var points = getTrendPoints(_dailyConcentration);
    averageSpots.add(
        FlSpot(spots.first.x, ((points['yStart'] ?? 50).toInt()).toDouble()));
    averageSpots
        .add(FlSpot(spots.last.x, ((points['yEnd'] ?? 50).toInt()).toDouble()));

    Color trendColor = (points['yStart'] ?? 50) <= (points['yEnd'] ?? 50)
        ? Colors.green
        : Colors.red;

    averageSpots.sort((a, b) => a.x.compareTo(b.x));
    String chartTitle =
        "Статистика работы за - ${DateFormat('MMMM', 'ru_RU').format(DateTime.now())}";
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: 0.01,
            getTitlesWidget: (value, meta) {
              log('созадн bottomTitles - ${meta.min}');
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                    DateFormat('EE', 'ru_RU').format(doubleToDate(value)),
                    style: AppThemeModel.infoTextStyle),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 100,
            reservedSize: 50,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${(value).toInt()}",
                      style: AppThemeModel.infoTextStyle),
                ],
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false, // Убрана рамка вокруг графика
      ),
      minX: spots.first.x,
      maxX: spots.last.x,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Плавное исчезновение к низу с помощью прозрачности
              colors: [
                Colors.white.withOpacity(1),
                Colors.white.withOpacity(0)
              ],
            ),
          ),
        ),
        LineChartBarData(
          spots: averageSpots,
          isCurved: true,
          color: trendColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Плавное исчезновение к низу с помощью прозрачности
              colors: [trendColor.withOpacity(0.33), trendColor.withOpacity(0)],
            ),
          ),
        ),
      ],
    );
  }
}
