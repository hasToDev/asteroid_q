import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  late AnimationController _controlASTEROID;
  late Animation<double> _animationASTEROID;
  late Animation<double> _animationBLAST;

  int updateMarks = 0;
  bool destroyed = false;

  @override
  void initState() {
    super.initState();
    _controlASTEROID = AnimationController(vsync: this, duration: normalAnimationDuration);

    _animationASTEROID = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controlASTEROID, curve: Curves.easeOutExpo),
    );

    _animationBLAST = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlASTEROID, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controlASTEROID.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemSize = getIt<GameBoardProvider>().gameItemSize;
        Offset adjustedOffset = getIt<GameBoardProvider>().getIndexAdjustedOffset(widget.gridIndex);
        double itemSizeLOTTIE = itemSize * 5;
        Offset adjustedOffsetLOTTIE =
            getIt<GameBoardProvider>().getIndexAdjustedOffsetCUSTOMSIZE(widget.gridIndex, itemSizeLOTTIE);

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Consumer<AsteroidProvider>(
              builder: (BuildContext context, operation, Widget? _) {
                if (!destroyed && widget.gridIndex == operation.asteroidIndex && updateMarks != operation.updateMarks) {
                  updateMarks = operation.updateMarks;
                  getIt<AudioProvider>().sound(GameSound.explosion);
                  getIt<GameStatsProvider>().updateScore();
                  _controlASTEROID.forward().then((_) async {
                    destroyed = true;
                    await getIt<GameStatsProvider>().asteroidDestroyed(widget.gridIndex);
                    switch (operation.explosionReason) {
                      case AsteroidDestructionType.fighterJet:
                        getIt<FighterJetProvider>().recoverFromCollision();
                        break;
                      case AsteroidDestructionType.missile:
                        getIt<MissileProvider>().fireMissileDONE();
                        break;
                    }
                  });
                }
                return const SizedBox();
              },
            ),
            Positioned(
              left: adjustedOffset.dx,
              top: adjustedOffset.dy,
              child: ScaleTransition(
                scale: _animationASTEROID,
                child: FadeTransition(
                  opacity: _animationASTEROID,
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
            ),
            Positioned(
              left: adjustedOffsetLOTTIE.dx,
              top: adjustedOffsetLOTTIE.dy,
              child: Lottie.memory(
                getIt<AssetByteService>().animationBLAST!,
                controller: _animationBLAST,
                fit: BoxFit.contain,
                height: itemSizeLOTTIE,
                width: itemSizeLOTTIE,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ],
        );
      },
    );
  }
}
