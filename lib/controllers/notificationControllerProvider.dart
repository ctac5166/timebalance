import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timebalance/main.dart';

int id = 0;

class CountdownTimer {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final String channelId = 'countdown channel id';
  final String channelName = 'Countdown Channel';
  final String channelDescription = 'Channel for countdown notifications';

  int? notificationId;
  bool isRunning = false;
  DateTime? endTime;
  DateTime? startTime;
  DateTime? pausedAt;

  int? needTomatoes = 4;
  int? curentTomatoes = 0;
  int? concentrationLevel = 56;
  String title = "Концентрация";

  late ValueNotifier<int> remainingTimeNotifier;

  CountdownTimer(this.flutterLocalNotificationsPlugin) {
    remainingTimeNotifier = ValueNotifier<int>(0);
  }

  Future<void> startTimer(
    int seconds, {
    String? title,
    String? payload,
    bool updateTimeData = true,
  }) async {
    cancelCurrentNotification();
    notificationId = ++id;
    id++;
    if (updateTimeData) {
      startTime = DateTime.now();
    }
    if (updateTimeData) {
      endTime = DateTime.now().add(Duration(seconds: seconds - 4));
    }
    isRunning = true;

    _updateNotification(payload);

    logger.d("таймер $title был запущен");
    while (endTime!.difference(DateTime.now()).inSeconds > 0 && isRunning) {
      await Future.delayed(const Duration(seconds: 1));
      if (!isRunning) break;

      var remainingTime = endTime!.difference(DateTime.now()).inSeconds;
      remainingTimeNotifier.value = remainingTime;

      if (remainingTime <= 0) {
        completeNotification();
        break;
      }
    }
    logger.d("цикл таймера $title завершен");
  }

  String formatSecondsToTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return "$formattedHours:$formattedMinutes:$formattedSeconds";
  }

  Future<void> _updateNotification(String? payload) async {
    var totalTime = endTime!.difference(startTime!).inSeconds;
    var remainingTime = endTime!.difference(DateTime.now()).inSeconds;

    final AndroidNotificationDetails notificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showWhen: true,
            usesChronometer: true,
            chronometerCountDown: true,
            ongoing: true,
            when: endTime!.millisecondsSinceEpoch,
            showProgress: true,
            maxProgress: 100,
            progress: (((totalTime - remainingTime) / totalTime) * 100).toInt(),
            playSound: false,
            enableVibration: false,
            visibility: NotificationVisibility.public,
            icon: title == "Концентрация"
                ? "work_icon"
                : title == "Перерыв"
                    ? "break_icon"
                    : 'long_break_icon',
            largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
            // vibrationPattern: vibrationPattern,
            enableLights: true,
            color: const Color.fromARGB(255, 255, 0, 0),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500);
    await flutterLocalNotificationsPlugin.show(
      notificationId!,
      '🍅${(curentTomatoes! % needTomatoes!)}/$needTomatoes 🔥$concentrationLevel%\n$title',
      'Закончиться через ${formatSecondsToTime(endTime!.difference(DateTime.now()).inSeconds)}',
      NotificationDetails(android: notificationDetails),
      payload: payload,
    );
  }

  Future<void> stopTimer() async {
    logger.d("таймер $title был остановлен");
    isRunning = false;
    await cancelCurrentNotification();
    pausedAt = DateTime.now();

    final int remainingTimeInMilliseconds =
        endTime!.difference(DateTime.now()).inMilliseconds;

    var totalTime = endTime!.difference(startTime!).inSeconds;
    var remainingTime = endTime!.difference(DateTime.now()).inSeconds;

    final AndroidNotificationDetails stoppedNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: false,
            showWhen: true,
            ongoing: false,
            when: remainingTimeInMilliseconds,
            showProgress: true,
            maxProgress: 100,
            progress: (((totalTime - remainingTime) / totalTime) * 100).toInt(),
            playSound: false,
            enableVibration: false,
            visibility: NotificationVisibility.public,
            icon: 'pause',
            largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
            enableLights: true,
            color: const Color.fromARGB(255, 255, 0, 0),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500);

    logger.d(
        "|таймер на паузе|-> $totalTime=totalTime, $remainingTime=remainingTime");

    await flutterLocalNotificationsPlugin.show(
      notificationId!,
      '🍅${(curentTomatoes! % needTomatoes!)}/$needTomatoes 🔥$concentrationLevel%\nПауза-$title',
      '${(((totalTime - remainingTime) / totalTime) * 100).toInt()}% - выполнено',
      NotificationDetails(android: stoppedNotificationDetails),
      payload: 'timer_stopped',
    );
  }

  Future<void> resumeTimer() async {
    logger.d("таймер $title был возобновлен");
    if (notificationId == null || startTime == null || endTime == null) {
      throw Exception("Timer is not initialized or has no remaining time");
    }

    if (pausedAt != null) {
      endTime!.add(DateTime.now().difference(pausedAt!));
      pausedAt = null;
    }

    startTimer(endTime!.difference(startTime!).inSeconds,
        updateTimeData: false);
  }

  Future<void> completeNotification() async {
    logger.d("таймер $title был удален");
    await cancelCurrentNotification();
    notificationId = null;
    isRunning = false;
  }

  Future<void> cancelCurrentNotification() async {
    logger.d("уведомление была удалено");
    if (notificationId != null) {
      await flutterLocalNotificationsPlugin.cancel(notificationId!);
    }
  }

  bool timerIsActive() {
    if (notificationId == null || startTime == null || endTime == null) {
      return false;
    } else {
      return true;
    }
  }
}
