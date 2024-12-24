import 'dart:math' as math;
import 'dart:typed_data';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FighterJet extends StatefulWidget {
  final int initialIndex;
  final Offset initialOffset;
  final BoxConstraints initialConstraints;
  final FighterJetDirection initialDirection;
  final Uint8List imageBytes;

  const FighterJet({
    super.key,
    required this.initialIndex,
    required this.initialOffset,
    required this.initialConstraints,
    required this.initialDirection,
    required this.imageBytes,
  });

  @override
  State<FighterJet> createState() => _FighterJetState();
}

class _FighterJetState extends State<FighterJet> with TickerProviderStateMixin {
  late Offset _currentOffset;
  late BoxConstraints _currentConstraints;
  late FighterJetDirection _currentDirection;
  late int _currentIndex;

  late AnimationController _controlMOVE;
  late Animation<Offset> _animationMOVE;
  late AnimationController _controlROTATE;
  late Animation<double> _animationROTATE;

  double? currentItemSize;
  Widget? fighterJetCache;

  final double piMultiplier = (math.pi / 180);
  int updateMarks = 0;

  int statsMOVE = 0;
  int statsROTATE = 0;

  @override
  void initState() {
    super.initState();
    _controlMOVE = AnimationController(vsync: this);
    _animationMOVE = Tween<Offset>(begin: widget.initialOffset, end: widget.initialOffset)
        .animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));

    _controlROTATE = AnimationController(vsync: this);
    _animationROTATE = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _controlROTATE, curve: Curves.easeInOut),
    );

    _currentOffset = widget.initialOffset;
    _currentConstraints = widget.initialConstraints;
    _currentDirection = widget.initialDirection;
    _currentIndex = widget.initialIndex;
    context.read<FighterJetProvider>().setGridIndex(_currentIndex);
  }

  @override
  void dispose() {
    _controlMOVE.dispose();
    _controlROTATE.dispose();
    super.dispose();
  }

  void executeMOVE(FighterJetCommand command) {
    if (_currentDirection != command.direction) {
      rotateJET(command);
      return;
    }
    moveJET(command);
  }

  void moveJET(FighterJetCommand command) {
    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: command.offset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controlMOVE
        ..duration = const Duration(milliseconds: 500)
        ..forward(from: 0).then((_) {
          statsMOVE++;
          _currentOffset = _animationMOVE.value;
          bool nextCommandExists = context.read<FighterJetProvider>().commands.isNotEmpty;
          if (nextCommandExists) executeMOVE(context.read<FighterJetProvider>().commands.removeAt(0));
          // TODO: delete later
          if (!nextCommandExists) debugPrint('STATS Move($statsMOVE) Rotate($statsROTATE)');
        });
    });
  }

  void rotateJET(FighterJetCommand command) async {
    double startAngle = _currentDirection.angle;
    double endAngle = command.direction.angle;

    // calculate angle difference to prevent image rotating too much
    // endAngle value is adjusted to rotation is more than 180 degree either way
    double angleDifference = endAngle - startAngle;
    if (angleDifference > 180) endAngle = endAngle - 360;
    if (angleDifference < -180) endAngle = endAngle + 360;

    await Future.delayed(const Duration(milliseconds: 100));

    _animationROTATE = Tween<double>(begin: startAngle, end: endAngle).animate(
      CurvedAnimation(parent: _controlROTATE, curve: Curves.easeInOut),
    );

    _controlROTATE
      ..duration = const Duration(milliseconds: 500)
      ..forward(from: 0).then((_) async {
        statsROTATE++;
        _currentDirection = command.direction;
        moveJET(command);
      });
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
                  _currentIndex = operation.currentIndex;
                  switch (operation.action) {
                    case FighterJetAction.move:
                      executeMOVE(operation.commands.removeAt(0));
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
                  child: AnimatedBuilder(
                    animation: _animationROTATE,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(_animationROTATE.value * piMultiplier),
                        filterQuality: FilterQuality.high,
                        child: child,
                      );
                    },
                    child: Builder(builder: (context) {
                      if (currentItemSize == null || currentItemSize != null && currentItemSize != itemSize) {
                        currentItemSize = itemSize;
                        fighterJetCache = RepaintBoundary(
                          child: Image.memory(
                            widget.imageBytes,
                            height: itemSize,
                            width: itemSize,
                            fit: BoxFit.fitHeight,
                            filterQuality: FilterQuality.high,
                            gaplessPlayback: true,
                            isAntiAlias: true,
                          ),
                        );
                        return fighterJetCache!;
                      }

                      return fighterJetCache!;
                    }),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
