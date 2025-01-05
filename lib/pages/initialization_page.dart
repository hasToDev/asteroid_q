import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  void initState() {
    initializationCheck();
    super.initState();
  }

  void initializationCheck() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await getIt<AudioProvider>().initializeAudio();
    await getIt<LeaderboardSmallProvider>().loadLeaderboard();
    await getIt<LeaderboardMediumProvider>().loadLeaderboard();
    await getIt<LeaderboardLargeProvider>().loadLeaderboard();
    await getIt<GameStatsProvider>().loadMapFromStorage();
    if (!mounted) return;
    context.go(AppPaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
