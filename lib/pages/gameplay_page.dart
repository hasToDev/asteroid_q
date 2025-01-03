import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameplayPage extends StatefulWidget {
  final GamePlayPageExtra data;

  const GameplayPage({
    super.key,
    required this.data,
  });

  @override
  State<GameplayPage> createState() => _GameplayPageState();
}

class _GameplayPageState extends State<GameplayPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double innerShortestSide =
        GameBoardUtils.calculateInnerShortestSide(BoxConstraints(maxWidth: size.width, maxHeight: size.height));
    getIt<GameBoardProvider>().setInnerShortestSide(innerShortestSide, size);

    double horizontalSpace = size.width - size.height;
    if (horizontalSpace <= 0) horizontalSpace = 0;
    double verticalSpace = size.height - size.width;
    if (verticalSpace <= 0) verticalSpace = 0;

    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GameBoard(initialFocusIndex: widget.data.jetPositionIndex),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Builder(
                  builder: (context) {
                    if (horizontalSpace != 0) {
                      return GameLeftPanel(
                        horizontalSpace: horizontalSpace,
                        onTap: () async {
                          bool? exit = await getIt<DialogService>().exitConfirmation(context: context);
                          if (!context.mounted) return;
                          if (exit != null) context.go(AppPaths.home);
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Builder(
                  builder: (context) {
                    if (horizontalSpace != 0) {
                      return Column(
                        spacing: 12,
                        children: [
                          SizedBox(width: horizontalSpace / 2),
                          Selector<GameStatsProvider, int>(
                            selector: (context, stats) => stats.score,
                            builder: (context, scoreCount, child) {
                              return StatsWidget(
                                imageBytes: getIt<AssetByteService>().imageSCORE!,
                                score: scoreCount,
                                backgroundColor: scoreColor,
                              );
                            },
                          ),
                          Selector<GameStatsProvider, int>(
                            selector: (context, stats) => stats.fuel,
                            builder: (context, fuelCount, child) {
                              return StatsWidget(
                                imageBytes: getIt<AssetByteService>().imageFUELPOD!,
                                score: fuelCount,
                                backgroundColor: fuelColor,
                              );
                            },
                          ),
                          Selector<GameStatsProvider, int>(
                            selector: (context, stats) => stats.remainingLife,
                            builder: (context, lifeCount, child) {
                              return StatsWidget(
                                imageBytes: getIt<AssetByteService>().imageLIFE!,
                                score: lifeCount,
                                backgroundColor: lifeColor,
                              );
                            },
                          ),
                          const SizedBox(),
                          const SizedBox(),
                          Consumer<GameStatsProvider>(
                            builder: (BuildContext context, stats, Widget? _) {
                              return Column(
                                spacing: 12,
                                children: [
                                  StatsWidget(
                                    imageBytes: getIt<AssetByteService>().countDistance!,
                                    score: stats.spaceTravelled,
                                    backgroundColor: gameStatsColor,
                                  ),
                                  StatsWidget(
                                    imageBytes: getIt<AssetByteService>().countRotation!,
                                    score: stats.rotate,
                                    backgroundColor: gameStatsColor,
                                  ),
                                  StatsWidget(
                                    imageBytes: getIt<AssetByteService>().countRefuel!,
                                    score: stats.refuelCount,
                                    backgroundColor: gameStatsColor,
                                  ),
                                  StatsWidget(
                                    imageBytes: getIt<AssetByteService>().countGalaxy!,
                                    score: stats.galaxyCount,
                                    backgroundColor: gameStatsColor,
                                  ),
                                ],
                              );
                            },
                          ),
                          const Expanded(child: SizedBox()),
                          VirtualActionButton(
                            title: 'Shoot',
                            backgroundColor: scoreColor,
                            onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.shoot),
                          ),
                          VirtualActionButton(
                            title: 'Refuel',
                            backgroundColor: fuelColor,
                            onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.refuel),
                          ),
                          VirtualActionButton(
                            title: 'Move',
                            backgroundColor: gameStatsColor,
                            onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.move),
                          ),
                          const SizedBox(),
                          const SizedBox(),
                          const VirtualArrowButton(),
                          SizedBox(height: 4, width: horizontalSpace / 2),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
          IgnorePointer(
            child: Stack(
              children: [
                ...widget.data.galaxyData.items.map(
                  (position) {
                    if (position.type == GameObjectType.fuelPod) {
                      return Fuel(gridIndex: position.index, imageBytes: getIt<AssetByteService>().imageFUELPOD!);
                    }
                    return Asteroid(gridIndex: position.index, imageBytes: getIt<AssetByteService>().imageASTEROID!);
                  },
                ),
              ],
            ),
          ),
          IgnorePointer(
            child: LayoutBuilder(builder: (context, constraints) {
              return Missile(
                initialOffset: getIt<GameBoardProvider>().getIndexOffset(widget.data.jetPositionIndex),
                initialConstraints: constraints,
                imageBytes: getIt<AssetByteService>().imageMISSILE!,
              );
            }),
          ),
          IgnorePointer(
            child: LayoutBuilder(builder: (context, constraints) {
              return FighterJet(
                initialIndex: widget.data.jetPositionIndex,
                initialOffset: getIt<GameBoardProvider>().getIndexOffset(widget.data.jetPositionIndex),
                initialConstraints: constraints,
                initialDirection: widget.data.jetDirection,
                imageBytes: getIt<AssetByteService>().imageFIGHTERJET!,
              );
            }),
          ),
        ],
      ),
    );
  }
}
