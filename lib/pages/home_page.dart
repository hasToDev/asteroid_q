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
                  // TODO: create a check if there's a previous game that can be continue
                  // TODO: use previous game GalaxyCoordinates as input parameter if any
                  getIt<AudioProvider>().playerTapScreen();
                  getIt<GameFlowProvider>().startNewGame(context);
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
                      await getIt<DialogService>().exitConfirmation(context: context, type: ConfirmationDialog.signOut);
                  if (!context.mounted || signOut == null) {
                    isSigningOut = false;
                    return;
                  }

                  await getIt<LeaderboardSmallProvider>().removeFromStorage();
                  await getIt<LeaderboardMediumProvider>().removeFromStorage();
                  await getIt<LeaderboardLargeProvider>().removeFromStorage();
                  await getIt<AuthService>().signOut();
                  getIt<GameFlowProvider>().clearUsername();

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
