import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

/// [next_galaxy_tile.dart]
TextStyle? getWarpStyle(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 390) {
    return context.style.titleMedium?.copyWith(
      fontSize: 8,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    );
  }

  if (shortestSide < 450) {
    return context.style.titleMedium?.copyWith(
      fontSize: 10,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    );
  }

  if (shortestSide < 550) {
    return context.style.titleMedium?.copyWith(
      fontSize: 12,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    );
  }

  if (shortestSide < 700) {
    return context.style.titleMedium?.copyWith(
      fontSize: 15,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    );
  }

  return context.style.titleMedium?.copyWith(
    fontSize: 16,
    letterSpacing: 1.5,
    fontWeight: FontWeight.bold,
  );
}

/// [app_elevated_button.dart]
TextStyle? getAppElevatedStyle(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 450) {
    return context.style.titleSmall?.copyWith(
      fontSize: 12,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w500,
    );
  }

  return context.style.titleSmall?.copyWith(
    fontSize: 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w500,
  );
}

/// [dialog_service.dart]
TextStyle? getGameOverStyle(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 450) {
    return context.style.bodyLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  return context.style.bodyLarge?.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

/// [stats_widget.dart]
TextStyle? getStatsStyle(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 400) {
    return context.style.titleMedium?.copyWith(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  if (shortestSide < 450) {
    return context.style.titleMedium?.copyWith(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  if (shortestSide < 550) {
    return context.style.titleMedium?.copyWith(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  return context.style.titleMedium?.copyWith(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
