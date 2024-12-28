import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late AnimationController _controlFUELPOD;
  late Animation<double> _animationFUELPOD;

  int updateMarks = 0;
  bool harvested = false;

  @override
  void initState() {
    super.initState();
    _controlFUELPOD = AnimationController(vsync: this, duration: normalAnimationDuration);

    _animationFUELPOD = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controlFUELPOD, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controlFUELPOD.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double itemSize = getIt<GameBoardProvider>().gameItemSize;
      Offset adjustedOffset = getIt<GameBoardProvider>().getIndexAdjustedOffset(widget.gridIndex);

      return Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Consumer<FuelPodProvider>(
            builder: (BuildContext context, operation, Widget? _) {
              if (!harvested && widget.gridIndex == operation.fuelPodIndex && updateMarks != operation.updateMarks) {
                updateMarks = operation.updateMarks;
                getIt<AudioProvider>().sound(GameSound.refuel);
                getIt<FighterJetProvider>().refuelingSTART();
                _controlFUELPOD.forward().then((_) async {
                  harvested = true;
                  await getIt<GameStatsProvider>().fuelPodHarvested(widget.gridIndex);
                  getIt<FighterJetProvider>().refuelingEND();
                  getIt<FuelPodProvider>().fuelPodHarvestingDONE();
                });
              }
              return const SizedBox();
            },
          ),
          Positioned(
            left: adjustedOffset.dx,
            top: adjustedOffset.dy,
            child: ScaleTransition(
              scale: _animationFUELPOD,
              child: FadeTransition(
                opacity: _animationFUELPOD,
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
        ],
      );
    });
  }
}
