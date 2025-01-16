import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                          bool? exit = await getIt<DialogService>()
                              .confirmation(context: context, type: ConfirmationDialog.exitGame);
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
                      return GameRightPanel(horizontalSpace: horizontalSpace, screenHeight: size.height);
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Builder(
                  builder: (context) {
                    if (verticalSpace != 0) {
                      return GameTopPanel(
                        onTap: () async {
                          bool? exit = await getIt<DialogService>()
                              .confirmation(context: context, type: ConfirmationDialog.exitGame);
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
                alignment: Alignment.bottomCenter,
                child: Builder(
                  builder: (context) {
                    if (verticalSpace != 0) {
                      return const GameBottomPanel();
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
