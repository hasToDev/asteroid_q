import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTopPanel extends StatefulWidget {
  final VoidCallback onTap;

  const GameTopPanel({
    super.key,
    required this.onTap,
  });

  @override
  State<GameTopPanel> createState() => _GameTopPanelState();
}

class _GameTopPanelState extends State<GameTopPanel> {
  late Widget jetFighterStats;

  @override
  void initState() {
    jetFighterStats = Row(
      spacing: 8,
      children: [
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
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: getTopPanelSpacing(context),
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Image.memory(
                    getIt<AssetByteService>().imageEXIT!,
                    height: getStatsImageSize(context) * 2,
                    width: getStatsImageSize(context) * 2,
                    fit: BoxFit.fitHeight,
                    gaplessPlayback: true,
                    isAntiAlias: true,
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Builder(builder: (context) {
              double width = MediaQuery.sizeOf(context).width;
              if (width < 700) return const SizedBox();
              return jetFighterStats;
            }),
            Consumer<GameStatsProvider>(
              builder: (BuildContext context, stats, Widget? _) {
                return Row(
                  spacing: getTopPanelSpacing(context),
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
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
          ],
        ),
        Builder(builder: (context) {
          double width = MediaQuery.sizeOf(context).width;
          if (width >= 700) return const SizedBox();
          return Row(
            children: [
              const Expanded(child: SizedBox()),
              jetFighterStats,
              const SizedBox(width: 16),
            ],
          );
        }),
      ],
    );
  }
}
