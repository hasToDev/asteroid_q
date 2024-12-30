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
  late Animation<double> _animationOPACITY;

  late AnimationController _controlROTATE;
  late Animation<double> _animationROTATE;

  double? currentItemSize;
  Widget? fighterJetCache;

  final double piMultiplier = (math.pi / 180);
  int updateMarks = 0;

  int statsMOVE = 0;
  int statsROTATE = 0;

  bool collidedWithAsteroid = false;

  @override
  void initState() {
    super.initState();
    _controlMOVE = AnimationController(vsync: this);
    _animationMOVE = Tween<Offset>(begin: widget.initialOffset, end: widget.initialOffset)
        .animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));
    _animationOPACITY = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut),
    );

    _controlROTATE = AnimationController(vsync: this);
    _animationROTATE = Tween<double>(begin: widget.initialDirection.angle, end: widget.initialDirection.angle).animate(
      CurvedAnimation(parent: _controlROTATE, curve: Curves.easeInOut),
    );

    _currentOffset = widget.initialOffset;
    _currentConstraints = widget.initialConstraints;
    _currentDirection = widget.initialDirection;
    _currentIndex = widget.initialIndex;
    getIt<FighterJetProvider>().setGridIndex(_currentIndex);

    statsMOVE = getIt<GameStatsProvider>().spaceTravelled;
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

    bool nextCommandExists = getIt<FighterJetProvider>().commands.isNotEmpty;

    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: command.offset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut));

    // fade out jet if it is about to collide with asteroid
    // only happening on the last step of the command
    if (collidedWithAsteroid && !nextCommandExists) {
      _animationOPACITY = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controlMOVE, curve: EndLoadedCurve()),
      );
    }

    getIt<AudioProvider>().sound(GameSound.move);

    _controlMOVE
      ..duration = getAnimationDuration(command)
      ..forward(from: 0).then((_) {
        statsMOVE++;
        getIt<GameStatsProvider>().updateMoveStatsAndFuel(command.step);
        _currentOffset = _animationMOVE.value;
        if (nextCommandExists) {
          executeMOVE(getIt<FighterJetProvider>().commands.removeAt(0));
        } else {
          if (getIt<FighterJetProvider>().nextGalaxyDestination != null) {
            GalaxyCoordinates nextCoordinate = GridCoordinateUtils.getNextCoordinate(
                getIt<FighterJetProvider>().nextGalaxyDestination!, getIt<GameStatsProvider>().currentCoordinate);
            context.goWarp(
              WarpLoadingPageExtra(
                currentJetPositionIndex: getIt<FighterJetProvider>().nextGalaxyStartingIndex!,
                jetDirection: _currentDirection,
                transitionDirection: getIt<FighterJetProvider>().nextGalaxyDestination!.transitionDirection,
                galaxyCoordinates: nextCoordinate,
              ),
            );
            getIt<FighterJetProvider>().jetMovingToNewGalaxy();
          } else {
            if (collidedWithAsteroid) {
              getIt<AsteroidProvider>().asteroidExplosion(_currentIndex, AsteroidDestructionType.fighterJet);
              return;
            }
            getIt<FighterJetProvider>().jetFinishMoving();
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
        getIt<GameStatsProvider>().updateRotateStatsAndFuel();
        _currentDirection = command.direction;
        moveJET(command);
      });
  }

  void blinkingJET() async {
    await Future.delayed(const Duration(milliseconds: 75));

    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: _currentOffset,
    ).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.linear));

    // Create a sequence of fade in/out animations for 3 blinks
    _animationOPACITY = TweenSequence<double>([
      // First blink
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 16.67),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 16.67),
      // Second blink
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 16.67),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 16.67),
      // Third and final blink, higher weight to ensure final opacity is 1.0
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 33.32),
    ]).animate(CurvedAnimation(parent: _controlMOVE, curve: Curves.linear));

    getIt<AudioProvider>().sound(GameSound.lifeReduced);

    _controlMOVE
      ..duration = blinkingAnimationDuration
      ..forward(from: 0).then((_) {
        collidedWithAsteroid = false;
        getIt<FighterJetProvider>().jetFinishMoving();
        // reset _animationOPACITY
        _animationOPACITY = Tween<double>(begin: 1.0, end: 1.0).animate(
          CurvedAnimation(parent: _controlMOVE, curve: Curves.easeInOut),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
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
                        if (operation.commands.isNotEmpty) {
                          collidedWithAsteroid = false;
                          executeMOVE(operation.commands.removeAt(0));
                        }
                        break;
                      case FighterJetAction.asteroidCollision:
                        if (operation.commands.isNotEmpty) {
                          collidedWithAsteroid = true;
                          executeMOVE(operation.commands.removeAt(0));
                        }
                        break;
                      case FighterJetAction.collisionRecover:
                        blinkingJET();
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
                    _currentOffset = GameBoardUtils.findIndexOffset(
                        _currentIndex,
                        getIt<GameBoardProvider>().gridSize,
                        getIt<GameBoardProvider>().innerShortestSide,
                        Size(constraints.maxWidth, constraints.maxHeight));
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
                      child: FadeTransition(
                        opacity: _animationOPACITY,
                        child: Builder(
                          builder: (context) {
                            if (currentItemSize == null || currentItemSize != null && currentItemSize != itemSize) {
                              currentItemSize = itemSize;
                              fighterJetCache = Image.memory(
                                widget.imageBytes,
                                height: itemSize,
                                width: itemSize,
                                fit: BoxFit.fitHeight,
                                gaplessPlayback: true,
                                isAntiAlias: true,
                              );
                              return fighterJetCache!;
                            }

                            return fighterJetCache!;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
