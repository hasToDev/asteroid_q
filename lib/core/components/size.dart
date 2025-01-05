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

BoxConstraints getGameOverDialogConstraints(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 390) return const BoxConstraints(maxWidth: 250, minWidth: 250);
  if (shortestSide < 450) return const BoxConstraints(maxWidth: 330, minWidth: 330);

  return const BoxConstraints(maxWidth: 430, minWidth: 330);
}

double getDialogPaddingSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 390) return 16;

  return 24;
}

double getDialogInsetPaddingSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 390) return 12;

  return 16;
}

EdgeInsetsGeometry getTopPanelImagePadding(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 390) {
    return const EdgeInsets.only(left: 12, top: 4);
  }

  return const EdgeInsets.only(left: 16, top: 8);
}

double getLegendItemSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 450) return 70;

  return 80;
}

double getLegendItemSeparatorSize(BuildContext context) {
  double shortestSide = MediaQuery.sizeOf(context).shortestSide;

  if (shortestSide < 450) return 12;

  return 16;
}
