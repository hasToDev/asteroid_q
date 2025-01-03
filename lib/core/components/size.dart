import 'package:flutter/material.dart';

/// [stats_widget.dart]
double getStatsImageSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 370) return 18;
  if (shortestSide < 400) return 20;
  if (shortestSide < 450) return 24;
  if (shortestSide < 550) return 28;

  return 32.0;
}

double getStatsHorizontalPaddingSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 370) return 4;
  if (shortestSide < 450) return 6;

  return 10;
}

double getStatsContainerPaddingSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 370) return 2;
  if (shortestSide < 450) return 3;

  return 4;
}

double getControlImageSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 550) return 36;

  return 40.0;
}

double getBottomPanelSpacing(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 370) return 6;
  if (shortestSide < 450) return 8;
  if (shortestSide < 550) return 12;

  return 32;
}

double getBottomPanelBottomPadding(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 450) return 12;
  if (shortestSide < 550) return 16;

  return 24;
}

double getTopPanelSpacing(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 360) return 4;

  return 8;
}

EdgeInsetsGeometry getBottomPanelVirtualActionPadding(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 550) {
    return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  }

  return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
}
