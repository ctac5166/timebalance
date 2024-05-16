import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphicBottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const GlassmorphicBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<GlassmorphicBottomBar> createState() => _GlassmorphicBottomBarState();
}

class _GlassmorphicBottomBarState extends State<GlassmorphicBottomBar> {
  void _onItemTapped(int index) {
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildBarItem(
                  icon: Icons.bar_chart, title: "Аналитика", index: 0),
              _buildBarItem(icon: Icons.timer, title: "Таймер", index: 1),
              _buildBarItem(icon: Icons.apps, title: "Приложение", index: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarItem(
      {required IconData icon, required String title, required int index}) {
    final isActive = index == widget.selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white),
          Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.white),
          ),
          isActive
              ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 60,
                  color: Colors.white,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
