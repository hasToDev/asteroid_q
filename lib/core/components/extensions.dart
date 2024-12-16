import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enums.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

extension GoRouterStateX on GoRouterState {
  TransitionDirection? get transitionDirection {
    // return extra is Map<String, dynamic>
    //     ? (extra as Map<String, dynamic>)['transitionDirection'] as TransitionDirection?
    //     : null;

    return extra is TransitionDirection ? extra as TransitionDirection : null;
  }
}

extension BoxConstraintsX on BoxConstraints {
  bool isEqual(BoxConstraints constraints) => constraints.maxHeight == maxHeight && constraints.maxWidth == maxWidth;
}

extension BuildContextX on BuildContext {
  void goWithTransition(String location, {TransitionDirection? direction}) {
    // final extra = direction != null ? {'transitionDirection': direction} : null;
    // go(location, extra: extra);

    final extra = direction;
    go(location, extra: extra);
  }

  /// [style] shorten syntax for textTheme
  TextTheme get style => Theme.of(this).textTheme;
}

extension NextGalaxyX on NextGalaxy {
  int get id {
    switch (this) {
      case NextGalaxy.top:
        return 1111;
      case NextGalaxy.right:
        return 2222;
      case NextGalaxy.bottom:
        return 3333;
      case NextGalaxy.left:
        return 4444;
    }
  }
}

extension SpaceTilePositionX on SpaceTilePosition {
  int get id {
    switch (this) {
      case SpaceTilePosition.center:
        return 144;
      case SpaceTilePosition.top:
        return 8;
      case SpaceTilePosition.bottom:
        return 280;
      case SpaceTilePosition.left:
        return 136;
      case SpaceTilePosition.right:
        return 152;
    }
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
