import 'dart:async';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

import 'next_galaxy_tile.dart';
import 'space_tile.dart';

class GameBoard extends StatefulWidget {
  final int? initialFocusIndex;

  const GameBoard({
    super.key,
    this.initialFocusIndex,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int boxNumber = getIt<GameBoardProvider>().gridSize;
  double innerShortestSide = 0;

  ValueNotifier<int> focusedIndex = ValueNotifier<int>(SpaceTilePosition.center.id);

  late int itemCount;
  late int rows;
  late int columns;
  late FocusNode _focusNode;
  late StreamSubscription<VirtualAction> _subscription;

  @override
  void initState() {
    super.initState();
    itemCount = boxNumber * boxNumber;
    rows = boxNumber;
    columns = boxNumber;
    _focusNode = FocusNode();

    if (widget.initialFocusIndex != null) {
      focusedIndex = ValueNotifier<int>(widget.initialFocusIndex!);
    }

    _subscription = getIt<VirtualActionService>().messageStream.listen((VirtualAction action) {
      _handleVirtualAction(action);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    focusedIndex.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void moveToNextGalaxy(int index) {
    NextGalaxy nextGalaxy = index.getNextGalaxy;

    FurthestIndex furthestIndex =
        GameBoardUtils.findFurthestIndex(getIt<FighterJetProvider>().currentIndex, getIt<GameBoardProvider>().gridSize);

    getIt<FighterJetProvider>().moveJet(
        furthestIndex.nextFocusedIndex(nextGalaxy), MediaQuery.sizeOf(context), innerShortestSide,
        furthestIndex: furthestIndex, nextGalaxy: nextGalaxy);
  }

  Future<void> _updatePositionOffset(int index) async {
    // update focused index
    focusedIndex.value = index;
  }

  void _move() {
    // prevent move if focusedIndex.value -1
    if (focusedIndex.value < 0) return;

    if (focusedIndex.value > getIt<GameBoardProvider>().maxIndexForGRidSize) {
      moveToNextGalaxy(focusedIndex.value);
    } else {
      getIt<FighterJetProvider>().moveJet(focusedIndex.value, MediaQuery.sizeOf(context), innerShortestSide);
    }
  }

  void _refuel() {
    if (getIt<FighterJetProvider>().isJetMoving) return;
    bool fuelExist = getIt<GameStatsProvider>().fuelPodIndices.contains(getIt<FighterJetProvider>().currentIndex);
    if (fuelExist) getIt<FuelPodProvider>().fuelPodHarvesting(getIt<FighterJetProvider>().currentIndex);
  }

  void _shoot() {
    if (getIt<FighterJetProvider>().isJetMoving) return;
    getIt<MissileProvider>().fireMissile(MediaQuery.sizeOf(context), innerShortestSide);
  }

  void _handleKeyEvent(KeyEvent event) {
    var (KeyboardAction action, int nextFocusIndex) = KeyboardInput.gameBoard(event, focusedIndex.value, boxNumber);
    switch (action) {
      case KeyboardAction.select:
        if (nextFocusIndex != focusedIndex.value) {
          _updatePositionOffset(nextFocusIndex);
        }
        break;
      case KeyboardAction.move:
        _move();
        break;
      case KeyboardAction.upgrade:
        // TODO: implement upgrade in the future
        break;
      case KeyboardAction.refuel:
        _refuel();
        break;
      case KeyboardAction.shoot:
        _shoot();
        break;
      case KeyboardAction.none:
        break;
    }
  }

  void _handleMouseEvent(PointerDownEvent event, int index) async {
    // event.buttons contains a bit field of pressed buttons
    // Primary (left) = 1
    // Secondary (right) = 2
    // Middle = 4
    switch (event.buttons) {
      case 1:
        if (index != focusedIndex.value) await _updatePositionOffset(index);
        _move(); // Left Click or onTap
        break;
      case 2:
        _shoot(); // Right Click
        break;
      case 4:
        _refuel(); // Middle Click
        break;
      default:
        break;
    }
  }

  void _handleVirtualAction(VirtualAction virtualAction) {
    var (KeyboardAction action, int nextFocusIndex) =
        KeyboardInput.forVirtualAction(virtualAction, focusedIndex.value, boxNumber);
    switch (action) {
      case KeyboardAction.select:
        if (nextFocusIndex != focusedIndex.value) {
          _updatePositionOffset(nextFocusIndex);
        }
        break;
      case KeyboardAction.move:
        _move();
        break;
      case KeyboardAction.upgrade:
        // TODO: implement upgrade in the future
        break;
      case KeyboardAction.refuel:
        _refuel();
        break;
      case KeyboardAction.shoot:
        _shoot();
        break;
      case KeyboardAction.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (boxNumber != getIt<GameBoardProvider>().gridSize) {
            boxNumber = getIt<GameBoardProvider>().gridSize;
            itemCount = boxNumber * boxNumber;
            rows = boxNumber;
            columns = boxNumber;
          }

          double outerShortestSide =
              constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;

          double outerItemSize = (outerShortestSide / (boxNumber + 2));
          double outerBorderRadius = outerItemSize * 0.25;
          double outerAxisSpacing = outerItemSize * 0.125;
          double outerSizedBoxSize = outerItemSize * boxNumber;

          double horizontalSpace = constraints.maxWidth - constraints.maxHeight;
          if (horizontalSpace <= 0) horizontalSpace = 0;
          double verticalSpace = constraints.maxHeight - constraints.maxWidth;
          if (verticalSpace <= 0) verticalSpace = 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                if (horizontalSpace != 0) return SizedBox(width: horizontalSpace / 2 + spaceFromScreenEdge);
                return const SizedBox(width: spaceFromScreenEdge);
              }),
              NextGalaxyTile(
                position: NextGalaxy.left,
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                borderRadius: outerBorderRadius,
                focusedIndex: focusedIndex,
                constraints: constraints,
                textOrientation: TextOrientation.left,
                onTapLeftClick: () => _move(),
              ),
              SizedBox(width: outerAxisSpacing * 2),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      if (verticalSpace != 0) return SizedBox(height: verticalSpace / 2 + spaceFromScreenEdge);
                      return const SizedBox(height: spaceFromScreenEdge);
                    }),
                    NextGalaxyTile(
                      position: NextGalaxy.top,
                      width: outerSizedBoxSize,
                      height: outerItemSize * 0.5,
                      borderRadius: outerBorderRadius,
                      focusedIndex: focusedIndex,
                      constraints: constraints,
                      textOrientation: TextOrientation.top,
                      onTapLeftClick: () => _move(),
                    ),
                    SizedBox(height: outerAxisSpacing),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        // ! NOTE
                        // ! innerShortestSide is always smaller than outerShortestSide
                        // ! because there are NextGalaxyTile wrapping GridView

                        // ! always use itemSize calculated with innerShortestSide
                        // ! to get correct offset or recalculated offset for the game
                        innerShortestSide =
                            constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;

                        double itemSize = (innerShortestSide / boxNumber);
                        double borderRadius = itemSize * 0.25;
                        double axisSpacing = itemSize * axisSpacingMultiplier;
                        double sizedBoxSize = itemSize * boxNumber;

                        return Center(
                          child: SizedBox(
                            width: sizedBoxSize,
                            height: sizedBoxSize,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: boxNumber,
                                ),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  return SpaceTile(
                                    index: index,
                                    spacing: axisSpacing,
                                    borderRadius: borderRadius,
                                    focusedIndex: focusedIndex,
                                    constraints: constraints,
                                    onMouseDown: (PointerDownEvent event) {
                                      _handleMouseEvent(event, index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: outerAxisSpacing),
                    NextGalaxyTile(
                      position: NextGalaxy.bottom,
                      width: outerSizedBoxSize,
                      height: outerItemSize * 0.5,
                      borderRadius: outerBorderRadius,
                      focusedIndex: focusedIndex,
                      constraints: constraints,
                      textOrientation: TextOrientation.bottom,
                      onTapLeftClick: () => _move(),
                    ),
                    Builder(builder: (context) {
                      if (verticalSpace != 0) return SizedBox(height: verticalSpace / 2 + spaceFromScreenEdge);
                      return const SizedBox(height: spaceFromScreenEdge);
                    }),
                  ],
                ),
              ),
              SizedBox(width: outerAxisSpacing * 2),
              NextGalaxyTile(
                position: NextGalaxy.right,
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                borderRadius: outerBorderRadius,
                focusedIndex: focusedIndex,
                constraints: constraints,
                textOrientation: TextOrientation.right,
                onTapLeftClick: () => _move(),
              ),
              Builder(builder: (context) {
                if (horizontalSpace != 0) return SizedBox(width: horizontalSpace / 2 + spaceFromScreenEdge);
                return const SizedBox(width: spaceFromScreenEdge);
              }),
            ],
          );
        },
      ),
    );
  }
}
