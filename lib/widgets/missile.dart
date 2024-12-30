import 'dart:math' as math;
import 'dart:typed_data';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Missile extends StatefulWidget {
  final Offset initialOffset;
  final BoxConstraints initialConstraints;
  final Uint8List imageBytes;

  const Missile({
    super.key,
    required this.initialOffset,
    required this.initialConstraints,
    required this.imageBytes,
  });

  @override
  State<Missile> createState() => _MissileState();
}

class _MissileState extends State<Missile> with SingleTickerProviderStateMixin {
  late AnimationController _controlMISSILE;
  late Animation<Offset> _animationMOVE;
  late Animation<double> _animationOPACITY;
  late Animation<double> _animationROTATE;

  final double piMultiplier = (math.pi / 180);

  late Offset _currentOffset;
  late BoxConstraints _currentConstraints;
  late int _currentIndex;

  int updateMarks = 0;

  bool destroyAsteroid = false;

  @override
  void initState() {
    super.initState();
    _controlMISSILE = AnimationController(vsync: this, duration: normalAnimationDuration);

    _animationMOVE = Tween<Offset>(begin: widget.initialOffset, end: widget.initialOffset)
        .animate(CurvedAnimation(parent: _controlMISSILE, curve: Curves.easeInOut));

    _animationOPACITY =
        Tween<double>(begin: 0.0, end: 0.0).animate(CurvedAnimation(parent: _controlMISSILE, curve: Curves.easeInOut));

    _animationROTATE =
        Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(parent: _controlMISSILE, curve: Curves.easeInOut));

    _currentOffset = widget.initialOffset;
    _currentConstraints = widget.initialConstraints;
    _currentIndex = getIt<FighterJetProvider>().currentIndex;
  }

  @override
  void dispose() {
    _controlMISSILE.dispose();
    super.dispose();
  }

  void moveMISSILE(FighterJetCommand command, BoxConstraints constraints) async {
    await Future.delayed(const Duration(milliseconds: 75));

    _currentOffset = GameBoardUtils.findIndexOffset(
      getIt<FighterJetProvider>().currentIndex,
      getIt<GameBoardProvider>().gridSize,
      getIt<GameBoardProvider>().innerShortestSide,
      Size(constraints.maxWidth, constraints.maxHeight),
    );

    _animationMOVE = Tween<Offset>(
      begin: _currentOffset,
      end: command.offset,
    ).animate(CurvedAnimation(parent: _controlMISSILE, curve: Curves.easeInOut));

    _animationOPACITY = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controlMISSILE, curve: EndLoadedCurve()),
    );

    _animationROTATE = Tween<double>(
      begin: getIt<FighterJetProvider>().currentDirection.angle,
      end: getIt<FighterJetProvider>().currentDirection.angle,
    ).animate(CurvedAnimation(parent: _controlMISSILE, curve: Curves.linear));

    getIt<AudioProvider>().sound(GameSound.laser);

    _controlMISSILE
      ..duration = quickAnimationDuration
      ..forward(from: 0).then(
        (_) {
          _currentOffset = _animationMOVE.value;
          if (destroyAsteroid) {
            getIt<AsteroidProvider>().asteroidExplosion(_currentIndex, AsteroidDestructionType.missile);
            return;
          }
          getIt<MissileProvider>().fireMissileDONE();
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Consumer<MissileProvider>(
              builder: (BuildContext context, operation, Widget? _) {
                if (updateMarks != operation.updateMarks) {
                  updateMarks = operation.updateMarks;
                  _currentIndex = operation.currentIndex;
                  switch (operation.action) {
                    case MissileAction.destroyAsteroid:
                      if (operation.commands.isNotEmpty) {
                        destroyAsteroid = true;
                        getIt<FighterJetProvider>().fireMissileSTART();
                        moveMISSILE(operation.commands.removeAt(0), constraints);
                      }
                      break;
                    case MissileAction.move:
                      if (operation.commands.isNotEmpty) {
                        destroyAsteroid = false;
                        getIt<FighterJetProvider>().fireMissileSTART();
                        moveMISSILE(operation.commands.removeAt(0), constraints);
                      }
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

                if (_controlMISSILE.isAnimating) {
                  offsetUsed = _animationMOVE.value;
                  _currentOffset = _animationMOVE.value;
                }

                // detect changes in layout
                // either because browser being resized or rotated screen
                if (!constraints.isEqual(_currentConstraints) && !_controlMISSILE.isAnimating) {
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
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(_animationROTATE.value * piMultiplier),
                    filterQuality: FilterQuality.medium,
                    child: FadeTransition(
                      opacity: _animationOPACITY,
                      child: Image.memory(
                        widget.imageBytes,
                        height: itemSize,
                        width: itemSize,
                        fit: BoxFit.fitHeight,
                        gaplessPlayback: true,
                        isAntiAlias: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
