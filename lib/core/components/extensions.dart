import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enums.dart';

extension GoRouterStateX on GoRouterState {
  TransitionDirection? get transitionDirection {
    return extra is Map<String, dynamic>
        ? (extra as Map<String, dynamic>)['transitionDirection'] as TransitionDirection?
        : null;
  }
}

extension BuildContextX on BuildContext {
  void goWithTransition(String location, {TransitionDirection? direction}) {
    final extra = direction != null ? {'transitionDirection': direction} : null;
    go(location, extra: extra);
  }
}