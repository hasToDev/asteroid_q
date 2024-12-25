import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class Fuel extends StatefulWidget {
  final int gridIndex;
  final Uint8List imageBytes;

  const Fuel({
    super.key,
    required this.gridIndex,
    required this.imageBytes,
  });

  @override
  State<Fuel> createState() => _FuelState();
}

class _FuelState extends State<Fuel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    return LayoutBuilder(builder: (context, constraints) {
      double innerShortestSide = GameBoardUtils.calculateInnerShortestSide(constraints);
      Offset offset = GameBoardUtils.findIndexOffset(
          widget.gridIndex, gridBoxNumber, innerShortestSide, Size(constraints.maxWidth, constraints.maxHeight));
      double itemSize = (innerShortestSide / gridBoxNumber);
      double axisSpacing = itemSize * axisSpacingMultiplier;
      itemSize = itemSize - axisSpacing;
      Offset adjustedOffset = Offset(offset.dx - (itemSize / 2), offset.dy - (itemSize / 2));
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
          //   left: adjustedOffset.dx,
          //   top: adjustedOffset.dy,
          //   child: ScaleTransition(
          //     scale: _scaleAnimation,
          //     child: FadeTransition(
          //       opacity: _fadeAnimation,
          //       child: Image.memory(
          //         widget.imageBytes,
          //         width: 40,
          //         height: 40,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
