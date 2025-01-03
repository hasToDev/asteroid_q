import 'package:asteroid_q/core/core.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Provider
    getIt.registerLazySingleton(() => AsteroidProvider());
    getIt.registerLazySingleton(() => AudioProvider());
    getIt.registerLazySingleton(() => FuelPodProvider());
    getIt.registerLazySingleton(() => GameBoardProvider());
    getIt.registerLazySingleton(() => GameFlowProvider());
    getIt.registerLazySingleton(() => GameStatsProvider());
    getIt.registerLazySingleton(() => FighterJetProvider());
    getIt.registerLazySingleton(() => MissileProvider());

    // Service
    getIt.registerLazySingletonAsync<AssetByteService>(() {
      return AssetByteService().initialize();
    });
    getIt.registerLazySingleton(() => DialogService());
  }
}
