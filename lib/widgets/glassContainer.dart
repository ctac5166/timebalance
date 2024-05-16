import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

import 'package:timebalance/main.dart';

enum ContainerMode {
  wrapContent,
  fillHorizontal,
  fillVertical,
  fillAll,
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final ContainerMode mode;
  final BorderRadius borderRadius;
  final VoidCallback? onTap; // Optional onTap callback

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.mode = ContainerMode.wrapContent,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onTap, // Accept onTap as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.6, sigmaY: 12.6),
        child: CustomPaint(
          painter: BorderPainter(borderRadius: borderRadius),
          child: InkWell(
            onTap: onTap, // Use the onTap callback here
            child: Container(
              padding: padding,
              decoration: const BoxDecoration(
                color: AppThemeModel.glassColor,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  switch (mode) {
                    case ContainerMode.wrapContent:
                      return child;
                    case ContainerMode.fillHorizontal:
                      return SizedBox(width: double.infinity, child: child);
                    case ContainerMode.fillVertical:
                      return SizedBox(height: double.infinity, child: child);
                    case ContainerMode.fillAll:
                      return SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: child);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final BorderRadius borderRadius;

  BorderPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppThemeModel.glassBorderColor.withOpacity(0.21)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
