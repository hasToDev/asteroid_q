import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/asteroid.dart';
import 'package:asteroid_q/widgets/fuel.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameplayPage extends StatefulWidget {
  const GameplayPage({
    super.key,
  });

  @override
  State<GameplayPage> createState() => _GameplayPageState();
}

class _GameplayPageState extends State<GameplayPage> {
  SpaceTilePosition initialJetPosition = SpaceTilePosition.center;
  late GalaxyData galaxyData;

  @override
  void initState() {
    galaxyData = GalaxyData(
      name: 'data',
      items: GameBoardUtils.generateGamePositions(fighterJetPosition: initialJetPosition.id),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeFocus(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(AppPaths.home);
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ),
              const Expanded(
                child: GameBoard(),
              ),
              const SizedBox(
                width: 200,
                child: Text('Gameplay Page'),
              ),
            ],
          ),
          // TODO: create widget based on gameObjects
          // TODO: the order in stack from top to bottom is : ROW, Missile, Asteroid, Fuel Pod, Fighter Jet
          // ...position.map(
          //   (position) {
          //     return Positioned(
          //       left: position.x,
          //       top: position.y,
          //       child: Container(
          //         width: 10,
          //         height: 10,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //     );
          //   },
          // ).toList(),
          Stack(
            children: [
              ...galaxyData.items.map(
                    (position) {
                  if (position.type == GameObjectType.fuelPod) {
                    return Fuel(gridIndex: position.index, imageBytes: getIt<ImageByteService>().fuelPod!);
                  }
                  return Asteroid(gridIndex: position.index, imageBytes: getIt<ImageByteService>().asteroid!);
                },
              ),
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
            Offset centerOffset = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
            return FighterJet(
              initialIndex: initialJetPosition.id,
              initialOffset: centerOffset,
              initialConstraints: constraints,
              initialDirection: FighterJetDirection.up,
              imageBytes: getIt<ImageByteService>().fighterJet!,
            );
          }),


        ],
      ),
    );
  }
}
