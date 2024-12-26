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
    _animationROTATE = Tween<double>(begin: widget.initialDirection.angle, end: widget.initialDirection.angle).animate(
      CurvedAnimation(parent: _controlROTATE, curve: Curves.easeInOut),
    );

    _currentOffset = widget.initialOffset;
    _currentConstraints = widget.initialConstraints;
    _currentDirection = widget.initialDirection;
    _currentIndex = widget.initialIndex;
    getIt<FighterJetProvider>().setGridIndex(_currentIndex);

    statsMOVE = getIt<GameStatsProvider>().move;
    statsROTATE = getIt<GameStatsProvider>().rotate;
  }

  @override
  void dispose() {
    _controlMOVE.dispose();
    _controlROTATE.dispose();
    super.dispose();
  }

  Duration getAnimationDuration(FighterJetCommand command) {
    return command.step == 0 ? zeroAnimationDuration : normalAnimationDuration;
  }

  void executeMOVE(FighterJetCommand command) {
    if (_currentDirection != command.direction) {
      rotateJET(command);
      return;
    }
    moveJET(command);
  }

  void moveJET(FighterJetCommand command) async {
    await Future.delayed(const Duration(milliseconds: 75));

    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: command.offset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));

    _controlMOVE
      ..duration = getAnimationDuration(command)
      ..forward(from: 0).then((_) {
        statsMOVE++;
        getIt<GameStatsProvider>().updateMove();
        _currentOffset = _animationMOVE.value;
        bool nextCommandExists = getIt<FighterJetProvider>().commands.isNotEmpty;
        if (nextCommandExists) {
          executeMOVE(getIt<FighterJetProvider>().commands.removeAt(0));
        } else {
          if (getIt<FighterJetProvider>().nextGalaxyDestination != null) {
            context.goWarp(
              WarpLoadingPageExtra(
                currentJetPositionIndex: getIt<FighterJetProvider>().nextGalaxyStartingIndex!,
                jetDirection: _currentDirection,
                transitionDirection: getIt<FighterJetProvider>().nextGalaxyDestination!.transitionDirection,
              ),
            );
            getIt<FighterJetProvider>().jetMovingToNewGalaxy();
          } else {
            getIt<FighterJetProvider>().jetFinishMoving();
            // TODO: delete later
            debugPrint('STATS Move($statsMOVE) Rotate($statsROTATE)');
          }
        }
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

    await Future.delayed(const Duration(milliseconds: 75));

    _animationROTATE = Tween<double>(begin: startAngle, end: endAngle).animate(
      CurvedAnimation(parent: _controlROTATE, curve: Curves.easeInOut),
    );

    _controlROTATE
      ..duration = const Duration(milliseconds: 500)
      ..forward(from: 0).then((_) async {
        statsROTATE++;
        getIt<GameStatsProvider>().updateRotate();
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
                      if (operation.commands.isNotEmpty) executeMOVE(operation.commands.removeAt(0));
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

                // detect changes in layout
                // either because browser being resized or rotated screen
                if (!constraints.isEqual(_currentConstraints) && !_controlMOVE.isAnimating) {
                  // _currentOffset = _currentOffset.recalculateOffset(
                  //   gridIndex: _currentIndex,
                  //   gridBoxNumber: gridBoxNumber,
                  //   innerShortestSide: innerShortestSide,
                  //   newConstraints: constraints,
                  // );
                  _currentOffset = GameBoardUtils.findIndexOffset(_currentIndex, getIt<GameBoardProvider>().gridSize,
                      getIt<GameBoardProvider>().innerShortestSide, Size(constraints.maxWidth, constraints.maxHeight));
                  _currentConstraints = constraints;
                  offsetUsed = _currentOffset;
                }

                double itemSize = getIt<GameBoardProvider>().gameItemSize;
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
                        filterQuality: FilterQuality.medium,
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
