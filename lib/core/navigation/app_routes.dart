import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppPaths.initialization,
    extraCodec: const _AppExtraCodec(),
    routes: [
      GoRoute(
        path: AppPaths.initialization,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const InitializationPage(),
        ),
      ),
      GoRoute(
        path: AppPaths.home,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const AuthenticatedView(child: HomePage()),
        ),
      ),
      GoRoute(
        path: AppPaths.audio,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const AudioPage(),
        ),
      ),
      GoRoute(
        path: AppPaths.gameplay,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: AuthenticatedView(child: GameplayPage(data: state.gamePlayExtra!)),
        ),
      ),
      GoRoute(
        path: AppPaths.leaderboard,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const LeaderboardPage(),
        ),
      ),
      GoRoute(
        path: AppPaths.username,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: const AuthenticatedView(child: UsernamePage()),
        ),
      ),
      GoRoute(
        path: AppPaths.warp,
        pageBuilder: (context, state) => _buildPageTransition(
          context: context,
          state: state,
          child: AuthenticatedView(child: WarpLoadingPage(data: state.warpExtra!)),
        ),
      ),
    ],
  );

  static Page<dynamic> _buildPageTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    TransitionDirection? direction = state.transitionDirection;

    // check direction in GamePlayPageExtra
    if (direction == null && state.gamePlayExtra != null) {
      direction = state.gamePlayExtra!.transitionDirection;
    }

    // check direction in WarpLoadingPageExtra
    if (direction == null && state.warpExtra != null) {
      direction = state.warpExtra!.transitionDirection;
    }

    if (direction == null) {
      return MaterialPage<T>(child: child);
    }

    return CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = _getBeginOffset(direction!);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Offset _getBeginOffset(TransitionDirection direction) {
    switch (direction) {
      case TransitionDirection.rightToLeft:
        return const Offset(1.0, 0.0);
      case TransitionDirection.leftToRight:
        return const Offset(-1.0, 0.0);
      case TransitionDirection.topToBottom:
        return const Offset(0.0, -1.0);
      case TransitionDirection.bottomToTop:
        return const Offset(0.0, 1.0);
    }
  }
}

/// A codec for GoRouter
class _AppExtraCodec extends Codec<Object?, Object?> {
  const _AppExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _AppExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _AppExtraEncoder();
}

/// Encoder
class _AppExtraEncoder extends Converter<Object?, Object?> {
  const _AppExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    switch (input) {
      case TransitionDirection _:
        return <Object?>['TransitionDirection', input.getString];
      case GamePlayPageExtra _:
        return <Object?>['GamePlayPageExtra', input];
      case WarpLoadingPageExtra _:
        return <Object?>['WarpLoadingPageExtra', input];
      default:
        throw FormatException('GoRouter _AppExtraEncoder cannot encode type ${input.runtimeType}');
    }
  }
}

/// Decoder
class _AppExtraDecoder extends Converter<Object?, Object?> {
  const _AppExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'TransitionDirection') {
      return (inputAsList[1] as String).getTransitionDirection;
    }
    if (inputAsList[0] == 'GamePlayPageExtra') {
      return inputAsList[1] as GamePlayPageExtra;
    }
    if (inputAsList[0] == 'WarpLoadingPageExtra') {
      return inputAsList[1] as WarpLoadingPageExtra;
    }
    throw FormatException('GoRouter _AppExtraDecoder unable to parse input: $input');
  }
}
