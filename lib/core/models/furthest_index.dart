import 'package:asteroid_q/core/core.dart';

class FurthestIndex {
  final int top;
  final int right;
  final int bottom;
  final int left;

  FurthestIndex({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  Map<String, dynamic> toJson() => {
        'top': top,
        'right': right,
        'bottom': bottom,
        'left': left,
      };

  factory FurthestIndex.fromJson(Map<String, dynamic> json) => FurthestIndex(
        top: json['top'] as int,
        bottom: json['bottom'] as int,
        right: json['right'] as int,
        left: json['left'] as int,
      );

  int nextFocusedIndex(NextGalaxy nextGalaxy) {
    switch (nextGalaxy) {
      case NextGalaxy.top:
        return top;
      case NextGalaxy.right:
        return right;
      case NextGalaxy.bottom:
        return bottom;
      case NextGalaxy.left:
        return left;
    }
  }

  int startingIndexOnNextGalaxy(NextGalaxy nextGalaxy) {
    switch (nextGalaxy) {
      case NextGalaxy.top:
        return bottom;
      case NextGalaxy.right:
        return left;
      case NextGalaxy.bottom:
        return top;
      case NextGalaxy.left:
        return right;
    }
  }

  @override
  String toString() {
    return 'FurthestIndex {top: $top, right: $right, bottom: $bottom, left: $left}';
  }
}
