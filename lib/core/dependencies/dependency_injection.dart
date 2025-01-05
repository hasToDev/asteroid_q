import 'package:asteroid_q/core/core.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Provider
    getIt.registerLazySingleton(() => AudioProvider());
    getIt.registerLazySingleton(() => MissileProvider());
    getIt.registerLazySingleton(() => FuelPodProvider());
    getIt.registerLazySingleton(() => GameFlowProvider());
    getIt.registerLazySingleton(() => AsteroidProvider());
    getIt.registerLazySingleton(() => GameBoardProvider());
    getIt.registerLazySingleton(() => GameStatsProvider());
    getIt.registerLazySingleton(() => FighterJetProvider());
    getIt.registerLazySingleton(() => LeaderboardSmallProvider());
    getIt.registerLazySingleton(() => LeaderboardLargeProvider());
    getIt.registerLazySingleton(() => LeaderboardMediumProvider());

    // Service
    getIt.registerLazySingleton(() => AuthService());
    getIt.registerLazySingleton(() => DialogService());
    getIt.registerLazySingleton(() => LeaderboardService());
    getIt.registerLazySingleton(() => VirtualActionService());
    getIt.registerLazySingletonAsync<AssetByteService>(() {
      return AssetByteService().initialize();
    });
  }
}
