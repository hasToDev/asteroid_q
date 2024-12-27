import 'package:asteroid_q/core/core.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Provider
    getIt.registerLazySingleton(() => GameBoardProvider());
    getIt.registerLazySingleton(() => GameStatsProvider());
    getIt.registerLazySingleton(() => FighterJetProvider());

    // Service
    getIt.registerLazySingletonAsync<AssetByteService>(() {
      return AssetByteService().initialize();
    });
  }
}
