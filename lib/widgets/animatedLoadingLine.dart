import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/main.dart';

class AnimatedLoadingLine extends ConsumerStatefulWidget {
  const AnimatedLoadingLine({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedLoadingLineState();
}

class _AnimatedLoadingLineState extends ConsumerState<AnimatedLoadingLine>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Используем 'this' для передачи TickerProvider
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: LinearProgressIndicator(
        value: _controller.value,
        backgroundColor: AppThemeModel.glassSecondColor,
        valueColor:
            const AlwaysStoppedAnimation<Color>(AppThemeModel.mainInfoColor),
      ),
    );
  }
}
