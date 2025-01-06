import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameFlowProvider extends ChangeNotifier {
  String userName = '';

  void gameOver(BuildContext context, String message) async {
    getIt<GameStatsProvider>().removeFromStorage();
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

  void continueGame(BuildContext context) async {
    await getIt<GameBoardProvider>().setGridSize(MediaQuery.sizeOf(context));
    if (!context.mounted) return;

    // to continue saved game, both of the following GalaxySize must be equal
    // different galaxy size means different screen size on player device
    GalaxySize gameBoardGalaxySize = getIt<GameBoardProvider>().galaxySize;
    GalaxySize gameStatsGalaxySize = getIt<GameStatsProvider>().currentCoordinate.size;
    if (gameBoardGalaxySize != gameStatsGalaxySize) {
      // TODO: notify player cannot continue previous game, in the future
      startNewGame(context);
      return;
    }

    context.goWarp(
      WarpLoadingPageExtra(
        currentJetPositionIndex: getIt<FighterJetProvider>().currentIndex,
        jetDirection: getIt<FighterJetProvider>().currentDirection,
        transitionDirection: TransitionDirection.bottomToTop,
        galaxyCoordinates: getIt<GameStatsProvider>().currentCoordinate,
      ),
    );
  }

  Future<bool> isUserSignedIn() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      return true;
    } on AuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loadUsername() async {
    if (userName.isNotEmpty) return true;
    bool isSignedIn = await isUserSignedIn();
    if (!isSignedIn) return false;
    userName = await getIt<AuthService>().getUserName();
    return true;
  }

  void clearUsername() => userName = '';
}
