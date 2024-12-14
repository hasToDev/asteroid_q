import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enums.dart';

extension GoRouterStateX on GoRouterState {
  TransitionDirection? get transitionDirection {
    // return extra is Map<String, dynamic>
    //     ? (extra as Map<String, dynamic>)['transitionDirection'] as TransitionDirection?
    //     : null;

    return extra is TransitionDirection ? extra as TransitionDirection : null;
  }
}

extension BuildContextX on BuildContext {
  void goWithTransition(String location, {TransitionDirection? direction}) {
    // final extra = direction != null ? {'transitionDirection': direction} : null;
    // go(location, extra: extra);

    final extra = direction;
    go(location, extra: extra);
  }
}

extension TransitionDirectionX on TransitionDirection {
  String get getString {
    switch (this) {
      case TransitionDirection.bottomToTop:
        return 'bottomToTop';
      case TransitionDirection.leftToRight:
        return 'leftToRight';
      case TransitionDirection.rightToLeft:
        return 'rightToLeft';
      case TransitionDirection.topToBottom:
        return 'topToBottom';
    }
  }
}

extension StringX on String {
  TransitionDirection get getTransitionDirection {
    switch (this) {
      case 'bottomToTop':
        return TransitionDirection.bottomToTop;
      case 'leftToRight':
        return TransitionDirection.leftToRight;
      case 'rightToLeft':
        return TransitionDirection.rightToLeft;
      case 'topToBottom':
        return TransitionDirection.topToBottom;
      default:
        return TransitionDirection.bottomToTop;
    }
  }
}
