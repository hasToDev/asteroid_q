import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/asteroid.dart';
import 'package:asteroid_q/widgets/fuel.dart';
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ExcludeFocus(
          //       child: SizedBox(
          //         width: 200,
          //         child: ElevatedButton(
          //           onPressed: () {
          //             context.go(AppPaths.home);
          //           },
          //           child: const Text('Back to Home'),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: GameBoard(initialFocusIndex: widget.data.jetPositionIndex),
          //     ),
          //     const SizedBox(
          //       width: 200,
          //       child: Text('Gameplay Page'),
          //     ),
          //   ],
          // ),
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Builder(
                  builder: (context) {
                    if (horizontalSpace != 0) {
                      return SizedBox(
                        width: horizontalSpace / 2,
                        child: const Text('Gameplay Page'),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Builder(
                  builder: (context) {
                    if (horizontalSpace != 0) {
                      return ExcludeFocus(
                        child: SizedBox(
                          width: horizontalSpace / 2,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go(AppPaths.home);
                            },
                            child: const Text('Back to Home'),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GameBoard(initialFocusIndex: widget.data.jetPositionIndex),
                  ),
                ],
              ),
            ],
          ),
          Stack(
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
          LayoutBuilder(builder: (context, constraints) {
            return Missile(
              initialOffset: getIt<GameBoardProvider>().getIndexOffset(widget.data.jetPositionIndex),
              initialConstraints: constraints,
              imageBytes: getIt<AssetByteService>().imageMISSILE!,
            );
          }),
          LayoutBuilder(builder: (context, constraints) {
            return FighterJet(
              initialIndex: widget.data.jetPositionIndex,
              initialOffset: getIt<GameBoardProvider>().getIndexOffset(widget.data.jetPositionIndex),
              initialConstraints: constraints,
              initialDirection: widget.data.jetDirection,
              imageBytes: getIt<AssetByteService>().imageFIGHTERJET!,
            );
          }),
        ],
      ),
    );
  }
}
