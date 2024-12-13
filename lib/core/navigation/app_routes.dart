import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/pages.dart';
import 'app_paths.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppPaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPaths.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppPaths.audio,
        builder: (context, state) => const AudioPage(),
      ),
      GoRoute(
        path: AppPaths.gameplay,
        builder: (context, state) => const GameplayPage(),
      ),
      GoRoute(
        path: AppPaths.leaderboard,
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: AppPaths.username,
        builder: (context, state) => const UsernamePage(),
      ),
    ],
  );
}