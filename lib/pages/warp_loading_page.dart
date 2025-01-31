import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class WarpLoadingPage extends StatefulWidget {
  final WarpLoadingPageExtra data;

  const WarpLoadingPage({
    super.key,
    required this.data,
  });

  @override
  State<WarpLoadingPage> createState() => _WarpLoadingPageState();
}

class _WarpLoadingPageState extends State<WarpLoadingPage> {
  final double maxImageSize = 500;

  @override
  void initState() {
    loadingLogic();
    super.initState();
  }

  loadingLogic() async {
    // game should not continue if unable to load username
    bool userNameLoaded = await getIt<GameFlowProvider>().loadUsername();
    if (!userNameLoaded) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      context.go(AppPaths.home);
      return;
    }

    int jetPositionIndex = widget.data.currentJetPositionIndex;

    GalaxyData? dataOnCoordinate = getIt<GameStatsProvider>().getGalaxyData(widget.data.galaxyCoordinates);
    if (dataOnCoordinate == null) {
      dataOnCoordinate = GalaxyData(
        name: widget.data.galaxyCoordinates.coordinateToKey(),
        items: GameBoardUtils.generateGamePositions(
          fighterJetPosition: jetPositionIndex,
          galaxySize: getIt<GameBoardProvider>().galaxySize,
          gridSize: getIt<GameBoardProvider>().maxIndexForGRidSize,
        ),
      );
      getIt<GameStatsProvider>().updateVisitedGalaxyCount();
      getIt<GameStatsProvider>().saveGalaxyData(widget.data.galaxyCoordinates, dataOnCoordinate);
    }

    getIt<GameStatsProvider>().saveCoordinate(widget.data.galaxyCoordinates);
    await getIt<GameStatsProvider>().processGalaxyData(dataOnCoordinate);

    // reset Asteroid and Fuel Pod to avoid accidental rebuild that makes Asteroid destroyed or Fuel Pod harvested
    getIt<AsteroidProvider>().resetIndex();
    getIt<FuelPodProvider>().resetIndex();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    context.goGamePlay(
      GamePlayPageExtra(
        jetPositionIndex: jetPositionIndex,
        jetDirection: widget.data.jetDirection,
        galaxyData: dataOnCoordinate,
        transitionDirection: widget.data.transitionDirection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          double heightLimit = constraints.maxHeight >= maxImageSize ? maxImageSize : constraints.maxHeight;

          return Center(
            child: Lottie.memory(
              key: const ValueKey('animation-warp'),
              getIt<AssetByteService>().animationWARP!,
              fit: BoxFit.contain,
              height: heightLimit,
              width: heightLimit,
              filterQuality: FilterQuality.medium,
            ),
          );
        }),
      ),
    );
  }
}
