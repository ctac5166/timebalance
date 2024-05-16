import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/main.dart';

class ResetStepButton extends ConsumerStatefulWidget {
  const ResetStepButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetStepButtonState();
}

class _ResetStepButtonState extends ConsumerState<ResetStepButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ref.read(timerControllerProvider.notifier).resetStep();
        },
        icon: const Icon(
          Icons.history_outlined,
          color: AppThemeModel.mainInfoColor,
        ));
  }
}
