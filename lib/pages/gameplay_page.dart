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
          Stack(
            children: [
              ...widget.data.galaxyData.items.map(
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
              initialIndex: widget.data.jetPositionIndex,
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
