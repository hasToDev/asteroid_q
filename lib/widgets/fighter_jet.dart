import 'dart:math' as math;
import 'dart:typed_data';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FighterJet extends StatefulWidget {
  final int initialIndex;
  final Offset initialOffset;
  final BoxConstraints initialConstraints;
  final double initialAngle;
  final Uint8List imageBytes;

  const FighterJet({
    super.key,
    required this.initialIndex,
    required this.initialOffset,
    required this.initialConstraints,
    this.initialAngle = 0.0,
    required this.imageBytes,
  });

  @override
  State<FighterJet> createState() => _FighterJetState();
}

class _FighterJetState extends State<FighterJet> with SingleTickerProviderStateMixin {
  late Offset _currentOffset;
  late BoxConstraints _currentConstraints;
  late double _currentAngle;
  late int _currentIndex;

  late AnimationController _controlMOVE;
  late Animation<Offset> _animationMOVE;

  int updateMarks = 0;

  @override
  void initState() {
    super.initState();
    _controlMOVE = AnimationController(vsync: this);
    _animationMOVE = Tween<Offset>(
      begin: widget.initialOffset,
      end: widget.initialOffset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));
    _currentOffset = widget.initialOffset;
    _currentConstraints = widget.initialConstraints;
    _currentAngle = widget.initialAngle;
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controlMOVE.dispose();
    super.dispose();
  }

  void moveTo(Offset targetOffset) {
    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: targetOffset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controlMOVE
        ..duration = const Duration(milliseconds: 500)
        ..reset()
        ..forward().then((_) {
          _currentOffset = _animationMOVE.value;
        });
    });
  }

  void rotate(double degrees) {
    // setState(() {
    //   _currentAngle = (_currentAngle + degrees) % 360;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Consumer<FighterJetProvider>(
              builder: (BuildContext context, operation, Widget? _) {
                if (operation.action != FighterJetAction.none && updateMarks != operation.updateMarks) {
                  updateMarks = operation.updateMarks;
                  _currentIndex = operation.latestIndex;
                  switch (operation.action) {
                    case FighterJetAction.move:
                      moveTo(operation.targetOffset);
                      break;
                    case FighterJetAction.rotate:
                      rotate(operation.targetAngle);
                      break;
                    default:
                      break;
                  }
                }
                return const SizedBox();
              },
            ),
            AnimatedBuilder(
                animation: _animationMOVE,
                builder: (context, child) {
                  Offset offsetUsed = _currentOffset;

                  if (_controlMOVE.isAnimating) {
                    offsetUsed = _animationMOVE.value;
                    _currentOffset = _animationMOVE.value;
                  }

                  double outerShortestSide =
                      constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;
                  double outerItemSize = (outerShortestSide / (gridBoxNumber + 2));
                  double outerAxisSpacing = outerItemSize * 0.125;

                  // shortest side is HEIGHT
                  if (constraints.maxHeight < constraints.maxWidth) {
                    // * get the innerShortestSide by reducing outerShortestSide
                    // * with SizedBox height and NextGalaxyTile height in COLUMN children of game_board.dart
                    outerShortestSide = outerShortestSide -
                        (spaceFromScreenEdge * 2) -
                        ((outerItemSize * 0.5) * 2) -
                        (outerAxisSpacing * 2);
                  }
                  // shortest side is WIDTH
                  if (constraints.maxWidth < constraints.maxHeight) {
                    // * get the innerShortestSide by reducing outerShortestSide
                    // * with SizedBox width and NextGalaxyTile width in ROW children of game_board.dart
                    outerShortestSide = outerShortestSide - ((outerItemSize * 0.5) * 2) - ((outerAxisSpacing * 2) * 2);
                  }

                  double innerShortestSide = outerShortestSide;

                  // detect changes in layout
                  // either because browser being resized or rotated screen
                  if (!constraints.isEqual(_currentConstraints) && !_controlMOVE.isAnimating) {
                    _currentOffset = _currentOffset.recalculateOffset(
                      gridIndex: _currentIndex,
                      gridBoxNumber: gridBoxNumber,
                      innerShortestSide: innerShortestSide,
                      newConstraints: constraints,
                    );
                    _currentConstraints = constraints;
                    offsetUsed = _currentOffset;
                  }

                  double itemSize = (innerShortestSide / gridBoxNumber);
                  double axisSpacing = itemSize * 0.017;
                  itemSize = itemSize - axisSpacing;
                  Offset adjustedOffset = Offset(offsetUsed.dx - (itemSize / 2), offsetUsed.dy - (itemSize / 2));

                  return Positioned(
                    left: adjustedOffset.dx,
                    top: adjustedOffset.dy,
                    child: Transform.rotate(
                      angle: _currentAngle * math.pi / 180,
                      child: Image.memory(
                        widget.imageBytes,
                        height: itemSize,
                        fit: BoxFit.fitHeight,
                        filterQuality: FilterQuality.high,
                        gaplessPlayback: true,
                        isAntiAlias: true,
                      ),
                    ),
                  );
                }),
          ],
        );
      },
    );
  }
}
