import 'dart:convert';

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
          child: const HomePage(),
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
          child: const GameplayPage(),
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
          child: const UsernamePage(),
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

    if (direction == null) {
      return MaterialPage<T>(child: child);
    }

    return CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = _getBeginOffset(direction);
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
    throw FormatException('GoRouter _AppExtraDecoder unable to parse input: $input');
  }
}
