import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class Missile extends StatefulWidget {
  final int gridIndex;
  final Offset targetOffset;
  final Uint8List imageBytes;

  const Missile({
    super.key,
    required this.gridIndex,
    required this.targetOffset,
    required this.imageBytes,
  });

  @override
  State<Missile> createState() => _MissileState();
}

class _MissileState extends State<Missile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
          //   child: SlideTransition(
          //     position: _positionAnimation,
          //     child: ScaleTransition(
          //       scale: _scaleAnimation,
          //       child: FadeTransition(
          //         opacity: _fadeAnimation,
          //         child: Image.memory(
          //           widget.imageBytes,
          //           width: 30,
          //           height: 30,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
