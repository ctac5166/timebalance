import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart'; // Import necessary Flutter packages

class AnimatedBackground extends ConsumerStatefulWidget {
  const AnimatedBackground({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends ConsumerState<AnimatedBackground> {
  late final AnimatedMeshGradientController _controller =
      AnimatedMeshGradientController();

  @override
  void initState() {
    super.initState();
    log("animation start");
    _controller.start(); // Start the animation automatically
  }

  @override
  void dispose() {
    _controller.stop(); // Stop the animation when the widget is disposed
    log("animation stop");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("builded");
    _controller.start();
    return AnimatedMeshGradient(
      colors: [
        Colors.red,
        Colors.pink,
        Colors.pink.shade100,
        Colors.pink.shade900
        // Color.fromARGB(255, 218, 167, 187),
        // Color.fromARGB(255, 186, 124, 140),
        // Color.fromARGB(255, 248, 243, 245),
        // Color.fromARGB(255, 206, 106, 148),
      ],
      controller: _controller,
      options: AnimatedMeshGradientOptions(speed: 200),
      child: widget.child, // Your application's content
    );
  }
}
