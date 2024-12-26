import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Asteroid extends StatefulWidget {
  final int gridIndex;
  final Uint8List imageBytes;

  const Asteroid({
    super.key,
    required this.gridIndex,
    required this.imageBytes,
  });

  @override
  State<Asteroid> createState() => _AsteroidState();
}

class _AsteroidState extends State<Asteroid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemSize = getIt<GameBoardProvider>().gameItemSize;
        Offset adjustedOffset = getIt<GameBoardProvider>().getIndexAdjustedOffset(widget.gridIndex);

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned(
              left: adjustedOffset.dx,
              top: adjustedOffset.dy,
              child: Image.memory(
                widget.imageBytes,
                height: itemSize,
                width: itemSize,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
                isAntiAlias: true,
              ),
            ),
            // Positioned(
            //   left: offset.dx,
            //   top: offset.dy,
            //   child: ScaleTransition(
            //     scale: _scaleAnimation,
            //     child: FadeTransition(
            //       opacity: _fadeAnimation,
            //       child: Stack(
            //         children: [
            //           Image.memory(
            //             widget.imageBytes,
            //             width: 60,
            //             height: 60,
            //           ),
            //           // Lottie.asset(
            //           //   'assets/animations/asteroid_effect.json',
            //           //   width: 80,
            //           //   height: 80,
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
