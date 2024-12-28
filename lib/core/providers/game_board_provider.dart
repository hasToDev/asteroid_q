import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class GameBoardProvider extends ChangeNotifier {
  int gridSize = 15;
  int maxIndexForGRidSize = 225;
  GalaxySize galaxySize = GalaxySize.large;

  double innerShortestSide = 0;
  double gameItemSize = 0;
  Size currentScreenSize = Size.zero;

  // shortestSide >= 768 use gridSize 15
  // shortestSide >= 427 use gridSize 11
  // shortestSide < 427 use gridSize 9
  Future<void> setGridSize(Size screenSize) async {
    if (screenSize.shortestSide >= 768) {
      gridSize = 15;
      maxIndexForGRidSize = gridSize * gridSize;
      galaxySize = GalaxySize.large;
      return;
    }

    if (screenSize.shortestSide >= 427) {
      gridSize = 11;
      maxIndexForGRidSize = gridSize * gridSize;
      galaxySize = GalaxySize.medium;
      return;
    }

    gridSize = 9;
    maxIndexForGRidSize = gridSize * gridSize;
    galaxySize = GalaxySize.small;
  }

  setInnerShortestSide(double value, Size screenSize) {
    innerShortestSide = value;
    currentScreenSize = screenSize;
    _calculateGameItemSize(screenSize);
  }

  _calculateGameItemSize(Size screenSize) {
    double itemSize = (innerShortestSide / gridSize);
    double axisSpacing = itemSize * axisSpacingMultiplier;
    gameItemSize = itemSize - axisSpacing;
  }

  getIndexOffset(int gridIndex) {
    return GameBoardUtils.findIndexOffset(gridIndex, gridSize, innerShortestSide, currentScreenSize);
  }

  getIndexAdjustedOffset(int gridIndex) {
    Offset offset = GameBoardUtils.findIndexOffset(gridIndex, gridSize, innerShortestSide, currentScreenSize);
    return Offset(offset.dx - (gameItemSize / 2), offset.dy - (gameItemSize / 2));
  }

  getIndexAdjustedOffsetCUSTOMSIZE(int gridIndex, double itemSize) {
    Offset offset = GameBoardUtils.findIndexOffset(gridIndex, gridSize, innerShortestSide, currentScreenSize);
    return Offset(offset.dx - (itemSize / 2), offset.dy - (itemSize / 2));
  }
}
