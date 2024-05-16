import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/glassContainer.dart';

class PomodoroUpCounter extends ConsumerStatefulWidget {
  const PomodoroUpCounter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PomodoroUpCounterState();
}

class _PomodoroUpCounterState extends ConsumerState<PomodoroUpCounter> {
  @override
  Widget build(BuildContext context) {
    var timerState = ref.watch(timerControllerProvider);
    countdownTimer.curentTomatoes =
        timerState.dayStatistics.totalWorkTimeForTheEntireInterval ~/
            ref
                .read(timerControllerProvider.notifier)
                .getCurrentScheme()
                .workSessionTimeInSeconds;
    countdownTimer.needTomatoes = ref
            .read(timerControllerProvider.notifier)
            .getCurrentScheme()
            .numberOfSessionsBeforeLongBreak -
        (ref.read(timerControllerProvider.notifier).getCompletedSessions() %
            ref
                .read(timerControllerProvider.notifier)
                .getCurrentScheme()
                .numberOfSessionsBeforeLongBreak);
    return GlassContainer(
        child: Text(
      "Помидор ${timerState.dayStatistics.totalWorkTimeForTheEntireInterval ~/ ref.read(timerControllerProvider.notifier).getCurrentScheme().workSessionTimeInSeconds} (${ref.read(timerControllerProvider.notifier).getCurrentScheme().numberOfSessionsBeforeLongBreak - (ref.read(timerControllerProvider.notifier).getCompletedSessions() % ref.read(timerControllerProvider.notifier).getCurrentScheme().numberOfSessionsBeforeLongBreak)})",
      style: const TextStyle(color: AppThemeModel.mainInfoColor),
    ));
  }
}
