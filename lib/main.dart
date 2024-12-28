import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO: change Outlined & Elevated Button to Container due to extra padding bug in mobile web

void main() async {
  await DependencyInjection.init();
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
