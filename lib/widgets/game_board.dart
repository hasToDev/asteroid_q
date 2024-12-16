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
  int boxNumber = gridBoxNumber;
  double innerShortestSide = 0;

  Offset selectedOffset = Offset.zero;
  ValueNotifier<int> focusedIndex = ValueNotifier<int>(SpaceTilePosition.center.id);

  late int itemCount;
  late int rows;
  late int columns;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    itemCount = boxNumber * boxNumber;
    rows = boxNumber;
    columns = boxNumber;
    _focusNode = FocusNode();
    // selectedOffset = Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2);

    if (widget.initialFocusIndex != null) {
      focusedIndex = ValueNotifier<int>(widget.initialFocusIndex!);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    focusedIndex.dispose();
    super.dispose();
  }

  void _updatePositionOffset(int index) {
    // update focused index
    focusedIndex.value = index;

    // only update selectedOffset for space tile
    // next galaxy tile is excluded
    if (index > 288) return;

    // Calculate grid item position
    final row = index ~/ columns;
    final col = index % columns;

    final itemSize = innerShortestSide / columns;
    final gridSize = itemSize * columns;

    // Calculate the actual position considering grid is centered
    final screenSize = MediaQuery.sizeOf(context);
    final leftOffset = (screenSize.width - gridSize) / 2;
    final topOffset = (screenSize.height - gridSize) / 2;

    final itemX = leftOffset + (col * itemSize) + (itemSize / 2);
    final itemY = topOffset + (row * itemSize) + (itemSize / 2);

    selectedOffset = Offset(itemX, itemY);
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
        // TODO: implement select action
        debugPrint('move');
        if (selectedOffset == const Offset(0.0, 0.0)) return;
        getIt<FighterJetProvider>().moveJet(selectedOffset, focusedIndex.value);
        break;
      case KeyboardAction.upgrade:
        // TODO: Handle this case.
        break;
      case KeyboardAction.refuel:
        // TODO: Handle this case.
        break;
      case KeyboardAction.shoot:
        // TODO: Handle this case.
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
          double outerShortestSide =
              constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;

          double outerItemSize = (outerShortestSide / (boxNumber + 2));
          double outerBorderRadius = outerItemSize * 0.25;
          double outerAxisSpacing = outerItemSize * 0.125;
          double outerSizedBoxSize = outerItemSize * boxNumber;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NextGalaxyTile(
                position: NextGalaxy.left,
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                borderRadius: outerBorderRadius,
                focusedIndex: focusedIndex,
                constraints: constraints,
                onTap: () {
                  //
                },
              ),
              SizedBox(width: outerAxisSpacing * 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: spaceFromScreenEdge),
                  NextGalaxyTile(
                    position: NextGalaxy.top,
                    width: outerSizedBoxSize,
                    height: outerItemSize * 0.5,
                    borderRadius: outerBorderRadius,
                    focusedIndex: focusedIndex,
                    constraints: constraints,
                    onTap: () {
                      //
                    },
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
                      double axisSpacing = itemSize * 0.017;
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
                                  onTap: () => _updatePositionOffset(index),
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
                    onTap: () {
                      //
                    },
                  ),
                  const SizedBox(height: spaceFromScreenEdge),
                ],
              ),
              SizedBox(width: outerAxisSpacing * 2),
              NextGalaxyTile(
                position: NextGalaxy.right,
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                borderRadius: outerBorderRadius,
                focusedIndex: focusedIndex,
                constraints: constraints,
                onTap: () {
                  //
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
