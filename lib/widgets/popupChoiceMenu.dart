import 'package:flutter/material.dart';
import 'package:timebalance/main.dart';

class PopupChoiceMenu extends StatefulWidget {
  final List<Future Function(String)> actions;
  final List<String> labels;
  final List<String> uids;
  final IconData icon;
  final int initialSelectedIndex;

  const PopupChoiceMenu({
    super.key,
    required this.actions,
    required this.labels,
    required this.uids,
    this.icon = Icons.more_vert, // Иконка по умолчанию
    this.initialSelectedIndex =
        -1, // Значение по умолчанию (-1 означает отсутствие выбора)
  });

  @override
  _PopupChoiceMenuState createState() => _PopupChoiceMenuState();
}

class _PopupChoiceMenuState extends State<PopupChoiceMenu> {
  void _performAction(int index) {
    // Navigator.of(context).pop(); // Закрываем меню после выбора
    widget.actions[index](widget.uids[index]);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppThemeModel.glassColor,
      icon: Icon(widget.icon, color: AppThemeModel.mainInfoColor),
      onSelected: _performAction,
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<int>>.generate(widget.labels.length,
            (int index) {
          return PopupMenuItem<int>(
            value: index,
            child: Text(
              widget.labels[index],
              style: TextStyle(
                color: index == widget.initialSelectedIndex
                    ? AppThemeModel.glassColor
                    : AppThemeModel.mainInfoColor,
              ),
            ),
          );
        });
      },
    );
  }
}
