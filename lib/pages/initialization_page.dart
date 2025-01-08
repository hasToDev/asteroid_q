import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  double edgePadding = 16;

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
    await getIt<GameStatsProvider>().loadGameStatsFromStorage();
    await getIt<GameStatsProvider>().loadCoordinateFromStorage();
    if (!mounted) return;
    context.go(AppPaths.home);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double logoWidth = size.width - edgePadding * 2;
    if (logoWidth > 600) logoWidth = 600;
    double asteroidLogoHeight = logoWidth * 0.65;
    double logoHeight = asteroidLogoHeight * 0.25;

    double availableHeight = size.height - logoHeight - edgePadding * 2 - asteroidLogoHeight;
    if (availableHeight <= 0) {
      availableHeight = size.height - edgePadding * 2;
      asteroidLogoHeight = availableHeight * 0.8;
      logoHeight = availableHeight * 0.2;
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(edgePadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(
                getIt<AssetByteService>().appLogo!,
                fit: BoxFit.contain,
                height: asteroidLogoHeight,
                width: asteroidLogoHeight,
                gaplessPlayback: true,
                isAntiAlias: true,
              ),
              Image.memory(
                getIt<AssetByteService>().appTextLogo!,
                fit: BoxFit.contain,
                height: logoHeight,
                width: logoWidth,
                gaplessPlayback: true,
                isAntiAlias: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
