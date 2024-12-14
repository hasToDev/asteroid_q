import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Splash Page'),
            ElevatedButton(
              onPressed: () {
                context.go(AppPaths.home);
              },
              child: const Text('Go to Home'),
            ),
            AppElevatedButton(
              title: 'Elevated Button',
              onPressed: () {
                // context.go(AppPaths.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
