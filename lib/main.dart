import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  String region = const String.fromEnvironment('region');
  String accessKey = const String.fromEnvironment('accessKey');
  String secretKey = const String.fromEnvironment('secretKey');
  String sessionToken = const String.fromEnvironment('sessionToken');

  if (region.isEmpty || accessKey.isEmpty || secretKey.isEmpty || sessionToken.isEmpty) {
    debugPrint('ENV not initialized!');
    throw Exception();
  }

  await DependencyInjection.init(
    region: region,
    accessKey: accessKey,
    secretKey: secretKey,
    sessionToken: sessionToken,
  );
  await getIt.isReady<AssetByteService>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AsteroidProvider>(create: (_) => getIt<AsteroidProvider>()),
        ChangeNotifierProvider<AudioProvider>(create: (_) => getIt<AudioProvider>()),
        ChangeNotifierProvider<FuelPodProvider>(create: (_) => getIt<FuelPodProvider>()),
        ChangeNotifierProvider<GameBoardProvider>(create: (_) => getIt<GameBoardProvider>()),
        ChangeNotifierProvider<GameFlowProvider>(create: (_) => getIt<GameFlowProvider>()),
        ChangeNotifierProvider<GameStatsProvider>(create: (_) => getIt<GameStatsProvider>()),
        ChangeNotifierProvider<FighterJetProvider>(create: (_) => getIt<FighterJetProvider>()),
        ChangeNotifierProvider<MissileProvider>(create: (_) => getIt<MissileProvider>()),
      ],
      child: MaterialApp.router(
        title: 'Asteroid Q',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
