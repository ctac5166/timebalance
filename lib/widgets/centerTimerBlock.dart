import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/data/models/timerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/glassContainer.dart';

String formatTime(int? seconds, bool pad) {
  return (pad)
      ? "${(seconds! / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
      : (seconds! > 59)
          ? "${(seconds / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
          : seconds.toString();
}

class CenterTimerBlock extends ConsumerStatefulWidget {
  const CenterTimerBlock({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CenterTimerBlockState();
}

class _CenterTimerBlockState extends ConsumerState<CenterTimerBlock> {
  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(secs)}';
  }

  String formatSecondsToTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerControllerProvider);
    int remainingTime = timerState.remainingTimeInSeconds;

    int hours = remainingTime ~/ 3600;
    int minutes = (remainingTime % 3600) ~/ 60;
    int seconds = remainingTime % 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 28),
            Icon(
              timerState.currentState == StepType.pause
                  ? Icons.pause
                  : timerState.currentState == StepType.longDelayBeforeWork
                      ? Icons.pause_rounded
                      : timerState.currentState == StepType.delayBeforeWork
                          ? Icons.pause_rounded
                          : timerState.currentState == StepType.work
                              ? Icons.work_rounded
                              : timerState.currentState == StepType.longBreak
                                  ? Icons.ramen_dining_rounded
                                  : timerState.currentState ==
                                          StepType.shortBreak
                                      ? Icons.local_cafe_rounded
                                      : Icons.electric_bolt_rounded,
              color: AppThemeModel.mainInfoColor,
            ),
            const SizedBox(width: 8),
            Text(
              timerState.currentState == StepType.pause
                  ? "концентрация - пауза"
                  : timerState.currentState == StepType.longDelayBeforeWork
                      ? "длинный перерыв - пауза"
                      : timerState.currentState == StepType.delayBeforeWork
                          ? "короткий перерыв - пауза"
                          : timerState.currentState == StepType.work
                              ? "концентрация"
                              : timerState.currentState == StepType.longBreak
                                  ? "длинный перерыв"
                                  : timerState.currentState ==
                                          StepType.shortBreak
                                      ? "короткий перерыв"
                                      : "время начать концентрацию!",
              style: AppThemeModel.infoTextStyle,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 330,
          height: 320,
          child: GlassContainer(
            child: timerState.currentState == StepType.off
                ? Center(
                    child: Text(
                      formatSecondsToTime(ref
                          .read(timerControllerProvider.notifier)
                          .getCurrentScheme()
                          .workSessionTimeInSeconds),
                      style: AppThemeModel.bigCounterTextStyle,
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 750),
                          value: hours,
                          textStyle: AppThemeModel.bigCounterTextStyle,
                          wholeDigits: 2, // ensures two digits for hours
                        ),
                        const Text(
                          ":",
                          style: AppThemeModel.bigCounterTextStyle,
                        ),
                        AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 750),
                          value: minutes,
                          textStyle: AppThemeModel.bigCounterTextStyle,
                          wholeDigits: 2, // ensures two digits for minutes
                        ),
                        const Text(
                          ":",
                          style: AppThemeModel.bigCounterTextStyle,
                        ),
                        AnimatedFlipCounter(
                          duration: const Duration(milliseconds: 500),
                          value: seconds,
                          textStyle: AppThemeModel.bigCounterTextStyle,
                          wholeDigits: 2, // ensures two digits for seconds
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 340,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    ref.read(timerControllerProvider.notifier).subtractMinute();
                  },
                  icon: const Icon(
                    Icons.remove,
                    color: AppThemeModel.mainInfoColor,
                  )),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: () {
                    ref.read(timerControllerProvider.notifier).addMinute();
                  },
                  icon: const Icon(
                    Icons.alarm_add_rounded,
                    color: AppThemeModel.mainInfoColor,
                  )),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ],
    );
  }
}
