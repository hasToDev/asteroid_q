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
  double edgePadding = 16;
  bool isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double logoWidth = size.width - edgePadding * 2;
    if (logoWidth > 600) logoWidth = 600;
    double logoHeight = logoWidth * 0.16;

    if (size.height < 280) logoHeight = size.height - edgePadding * 2 - 151;

    return GestureDetector(
      onTap: () {
        getIt<AudioProvider>().playerTapScreen();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(edgePadding),
          child: Builder(builder: (context) {
            if (size.height < 185) return const SizedBox();

            return Center(
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(
                    getIt<AssetByteService>().appTextLogo!,
                    fit: BoxFit.contain,
                    height: logoHeight,
                    width: logoWidth,
                    gaplessPlayback: true,
                    isAntiAlias: true,
                  ),
                  const SizedBox(),
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
            );
          }),
        ),
      ),
    );
  }
}
