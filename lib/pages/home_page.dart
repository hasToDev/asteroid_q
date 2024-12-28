import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getIt<AudioProvider>().playerTapScreen();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppElevatedButton(
                title: 'Start',
                onPressed: () async {
                  // TODO: create a check if there's a previous game that can be continue
                  // TODO: use previous game GalaxyCoordinates as input parameter if any
                  getIt<AudioProvider>().playerTapScreen();
                  await getIt<GameBoardProvider>().setGridSize(MediaQuery.sizeOf(context));
                  if (!context.mounted) return;
                  context.goWarp(
                    WarpLoadingPageExtra(
                      currentJetPositionIndex: SpaceTilePosition.center.id,
                      jetDirection: FighterJetDirection.up,
                      transitionDirection: TransitionDirection.bottomToTop,
                      galaxyCoordinates: GalaxyCoordinates(x: 0, y: 0, size: getIt<GameBoardProvider>().galaxySize),
                    ),
                  );
                },
              ),
              AppElevatedButton(
                title: 'Leaderboard',
                onPressed: () {
                  getIt<AudioProvider>().playerTapScreen();
                  context.go(AppPaths.leaderboard);
                },
              ),
              AppElevatedButton(
                title: 'Username',
                onPressed: () {
                  getIt<AudioProvider>().playerTapScreen();
                  context.go(AppPaths.username);
                },
              ),
              AppElevatedButton(
                title: 'Audio',
                onPressed: () {
                  getIt<AudioProvider>().playerTapScreen();
                  context.go(AppPaths.audio);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
