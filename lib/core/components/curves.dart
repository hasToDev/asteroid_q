import 'package:flutter/animation.dart';

class EndLoadedCurve extends Curve {
  @override
  double transform(double t) {
    // Returns 0.0 for most of the animation duration
    // Only starts transitioning near the end
    if (t >= 0.8) {
      // Map the last 20% of the animation (0.8-1.0) to (0.0-1.0)
      return (t - 0.8) * 5;
    }
    return 0.0;
  }
}