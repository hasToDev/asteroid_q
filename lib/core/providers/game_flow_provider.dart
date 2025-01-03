import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameFlowProvider extends ChangeNotifier {
  void gameOver(BuildContext context, String message) async {
    bool? retry = await getIt<DialogService>().gameOver(context: context, description: message);
    if (!context.mounted) return;
    if (retry == null) {
      context.go(AppPaths.home);
    } else {
      startNewGame(context);
    }
  }

  void startNewGame(BuildContext context) async {
    await getIt<GameBoardProvider>().setGridSize(MediaQuery.sizeOf(context));
    if (!context.mounted) return;

    getIt<AsteroidProvider>().reset();
    getIt<FighterJetProvider>().reset();
    getIt<FuelPodProvider>().reset();
    getIt<GameStatsProvider>().reset();
    getIt<MissileProvider>().reset();

    context.goWarp(
      WarpLoadingPageExtra(
        startNew: true,
        currentJetPositionIndex: SpaceTilePosition.center.id,
        jetDirection: FighterJetDirection.up,
        transitionDirection: TransitionDirection.bottomToTop,
        galaxyCoordinates: GalaxyCoordinates(x: 0, y: 0, size: getIt<GameBoardProvider>().galaxySize),
      ),
    );
  }
}
