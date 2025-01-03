import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

/// [next_galaxy_tile.dart]
TextStyle? getWarpStyle(BuildContext context) {
  double maxHeight = MediaQuery.sizeOf(context).height;

  return context.style.titleMedium?.copyWith(
    fontSize: 16,
    letterSpacing: 1.5,
    fontWeight: FontWeight.bold,
  );
}

/// [app_elevated_button.dart]
TextStyle? getAppElevatedStyle(BuildContext context) {
  double maxHeight = MediaQuery.sizeOf(context).height;

  return context.style.titleSmall?.copyWith(
    fontSize: 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w500,
  );
}

/// [dialog_service.dart]
TextStyle? getGameOverStyle(BuildContext context) {
  double maxHeight = MediaQuery.sizeOf(context).height;

  return context.style.bodyLarge?.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

/// [stats_widget.dart]
TextStyle? getStatsStyle(BuildContext context) {
  double maxHeight = MediaQuery.sizeOf(context).height;

  return context.style.titleMedium?.copyWith(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
