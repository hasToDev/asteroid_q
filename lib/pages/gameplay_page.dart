import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameplayPage extends StatefulWidget {
  const GameplayPage({super.key});

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
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppPaths.home);
                  },
                  child: const Text('Back to Home'),
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
        ],
      ),
    );
  }
}
