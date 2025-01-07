import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameFlowProvider extends ChangeNotifier {
  String userName = '';

  void gameWinner(BuildContext context) async {
    // post leaderboard entry to DynamoDB
    getIt<LeaderboardService>().postLeaderboard(
      getIt<GameStatsProvider>().currentCoordinate.size,
      LeaderboardEntry(
        playerName: userName,
        distance: getIt<GameStatsProvider>().spaceTravelled,
        rotate: getIt<GameStatsProvider>().rotate,
        refuel: getIt<GameStatsProvider>().refuelCount,
        galaxy: getIt<GameStatsProvider>().galaxyCount,
        timestamp: DateTime.now(),
      ),
    );

    getIt<GameStatsProvider>().removeFromStorage();
    getIt<AudioProvider>().sound(GameSound.won);
    bool? seeLeaderboard = await getIt<DialogService>().gameWinner(context: context);
    if (!context.mounted) return;
    if (seeLeaderboard == null) {
      context.go(AppPaths.home);
    } else {
      context.go(AppPaths.leaderboard);
    }
  }

  void gameOver(BuildContext context, String message) async {
    getIt<GameStatsProvider>().removeFromStorage();
    getIt<AudioProvider>().sound(GameSound.lose);
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

  Future<bool> loadUsername() async {
    if (userName.isNotEmpty) return true;
    bool isSignedIn = await getIt<AuthService>().isUserSignedIn();
    if (!isSignedIn) return false;
    userName = await getIt<AuthService>().getUserName();
    return true;
  }

  Future<void> signOut() async {
    await getIt<LeaderboardSmallProvider>().removeFromStorage();
    await getIt<LeaderboardMediumProvider>().removeFromStorage();
    await getIt<LeaderboardLargeProvider>().removeFromStorage();
    await getIt<GameStatsProvider>().removeFromStorage();
    await getIt<AuthService>().signOut();
    getIt<AsteroidProvider>().reset();
    getIt<FighterJetProvider>().reset();
    getIt<FuelPodProvider>().reset();
    getIt<GameStatsProvider>().reset();
    getIt<MissileProvider>().reset();
    clearUsername();
  }

  void clearUsername() => userName = '';
}
