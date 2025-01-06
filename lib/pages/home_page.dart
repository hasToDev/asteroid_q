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
  bool isSigningOut = false;

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
                  getIt<AudioProvider>().playerTapScreen();
                  bool isMapEmpty = getIt<GameStatsProvider>().gameMap.isEmpty;
                  if (isMapEmpty) {
                    getIt<GameFlowProvider>().startNewGame(context);
                  } else {
                    bool? continueGame = await getIt<DialogService>()
                        .confirmation(context: context, type: ConfirmationDialog.continueGame);
                    if (!context.mounted) return;
                    if (continueGame != null) {
                      getIt<GameFlowProvider>().continueGame(context);
                    } else {
                      getIt<GameFlowProvider>().startNewGame(context);
                    }
                  }
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
              AppElevatedButton(
                title: 'Sign Out',
                onPressed: () async {
                  if (isSigningOut) return;
                  isSigningOut = true;

                  bool? signOut =
                      await getIt<DialogService>().confirmation(context: context, type: ConfirmationDialog.signOut);
                  if (!context.mounted || signOut == null) {
                    isSigningOut = false;
                    return;
                  }

                  await getIt<GameFlowProvider>().signOut();
                  isSigningOut = false;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
