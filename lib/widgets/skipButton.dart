import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/main.dart';

class SkipButton extends ConsumerStatefulWidget {
  const SkipButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SkipButtonState();
}

class _SkipButtonState extends ConsumerState<SkipButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          ref
              .read(timerControllerProvider.notifier)
              .transitionToNextStep(stageSkip: true, userInput: true);
        },
        icon: const Icon(
          Icons.skip_next_rounded,
          color: AppThemeModel.mainInfoColor,
        ));
  }
}
