import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/glassContainer.dart';

class GlassNumberPickerDialog extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onValueSelected;
  final String prefixName;
  final int minValue;
  final int maxValue;
  final String variableName;

  const GlassNumberPickerDialog({
    super.key,
    required this.initialValue,
    required this.onValueSelected,
    this.prefixName = "Выберите время",
    this.minValue = 0,
    this.maxValue = 240,
    this.variableName = "мин",
  });

  @override
  _GlassNumberPickerDialogState createState() =>
      _GlassNumberPickerDialogState();
}

class _GlassNumberPickerDialogState extends State<GlassNumberPickerDialog> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(20),
        mode: ContainerMode.wrapContent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${widget.prefixName} (${widget.variableName})",
                style: AppThemeModel.infoTextStyle),
            const SizedBox(height: 16),
            NumberPicker(
              value: _currentValue,
              maxValue: widget.maxValue,
              minValue: widget.minValue,
              step: 1,
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
              textStyle: AppThemeModel.infoTextSecondStyle,
              selectedTextStyle: AppThemeModel.infoTextStyle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onValueSelected(_currentValue);
                Navigator.of(context).pop();
              },
              child: Text(
                "Выбрать (${widget.variableName})",
                style: AppThemeModel.infoTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
