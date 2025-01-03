import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameRightPanel extends StatelessWidget {
  final double horizontalSpace;

  const GameRightPanel({
    super.key,
    required this.horizontalSpace,
  });

  @override
  Widget build(BuildContext context) {
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
}
