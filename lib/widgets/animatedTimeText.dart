import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timebalance/main.dart';

class AnimatedTimeText extends StatefulWidget {
  final int seconds;

  const AnimatedTimeText({super.key, required this.seconds});

  @override
  _AnimatedTimeTextState createState() => _AnimatedTimeTextState();
}

class _AnimatedTimeTextState extends State<AnimatedTimeText>
    with SingleTickerProviderStateMixin {
  late List<String> currentDigits;
  late List<String> previousDigits;
  List<AnimationController> _controllers = [];
  List<Animation<double>> _opacityAnimations = [];
  List<Animation<Offset>> _offsetAnimations = [];

  Widget buildDigit(String digit, String previousDigit, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: _offsetAnimations[index].value *
                  20, // умножаем на 20 для увеличения дистанции движения
              child: Opacity(
                opacity: _opacityAnimations[index].value,
                child: Text(digit, style: AppThemeModel.bigCounterTextStyle),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    currentDigits = _splitDigits(widget.seconds);
    previousDigits = List.from(currentDigits);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
        currentDigits.length,
        (index) => AnimationController(
            vsync:
                this, // Now using TickerProviderStateMixin for multiple tickers
            duration: const Duration(milliseconds: 300)));
    _opacityAnimations = _controllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();
    _offsetAnimations = _controllers
        .map((controller) => Tween<Offset>(
                begin: const Offset(0, -0.1), end: Offset.zero)
            .animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();
  }

  @override
  void didUpdateWidget(AnimatedTimeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    List<String> newDigits = _splitDigits(widget.seconds);
    if (!listEquals(newDigits, currentDigits)) {
      previousDigits = List.from(currentDigits);
      currentDigits = newDigits;
      for (var i = 0; i < _controllers.length; i++) {
        _controllers[i].forward(from: 0);
      }
    }
  }

  List<String> _splitDigits(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return [
      (hours ~/ 10).toString(),
      (hours % 10).toString(),
      (minutes ~/ 10).toString(),
      (minutes % 10).toString(),
      (secs ~/ 10).toString(),
      (secs % 10).toString()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          currentDigits.length,
          (index) =>
              buildDigit(currentDigits[index], previousDigits[index], index)),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
