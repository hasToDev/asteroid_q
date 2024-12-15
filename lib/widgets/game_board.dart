import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    super.key,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int boxNumber = 17;
  late int itemCount;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    itemCount = boxNumber * boxNumber;
    _focusNode = FocusNode();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW:
        case LogicalKeyboardKey.arrowUp:
          // Handle up movement
          debugPrint('up');
          break;
        case LogicalKeyboardKey.keyS:
        case LogicalKeyboardKey.arrowDown:
          // Handle down movement
          debugPrint('down');
          break;
        case LogicalKeyboardKey.keyA:
        case LogicalKeyboardKey.arrowLeft:
          // Handle left movement
          debugPrint('left');
          break;
        case LogicalKeyboardKey.keyD:
        case LogicalKeyboardKey.arrowRight:
          // Handle right movement
          debugPrint('right');
          break;
        case LogicalKeyboardKey.keyU:
          // Handle U key
          debugPrint('U');
          break;
        case LogicalKeyboardKey.keyH:
          // Handle H key
          debugPrint('H');
          break;
        case LogicalKeyboardKey.keyR:
          // Handle R key
          debugPrint('R');
          break;
        case LogicalKeyboardKey.space:
          // Handle space
          debugPrint('Space');
          break;
        case LogicalKeyboardKey.enter:
          // Handle enter
          debugPrint('Enter');
          break;
      }
    } else if (event is KeyUpEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW:
        case LogicalKeyboardKey.arrowUp:
          // Handle up movement
          debugPrint('DONE up');
          break;
        case LogicalKeyboardKey.keyS:
        case LogicalKeyboardKey.arrowDown:
          // Handle down movement
          debugPrint('DONE down');
          break;
        case LogicalKeyboardKey.keyA:
        case LogicalKeyboardKey.arrowLeft:
          // Handle left movement
          debugPrint('DONE left');
          break;
        case LogicalKeyboardKey.keyD:
        case LogicalKeyboardKey.arrowRight:
          // Handle right movement
          debugPrint('DONE right');
          break;
        default:
          // Handle the rest of key
          debugPrint('DONE');
          break;
      }
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

          double outerItemSize = (outerShortestSide / (boxNumber + 2)).floorToDouble();
          double outerBorderRadius = outerItemSize * 0.25;
          double outerAxisSpacing = outerItemSize * 0.125;
          double outerSizedBoxSize = outerItemSize * boxNumber;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(outerBorderRadius),
                ),
              ),
              SizedBox(width: outerAxisSpacing * 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: outerSizedBoxSize,
                    height: outerItemSize * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(outerBorderRadius),
                    ),
                  ),
                  SizedBox(height: outerAxisSpacing),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      double shortestSide =
                          constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;

                      double itemSize = (shortestSide / boxNumber).floorToDouble();
                      double borderRadius = itemSize * 0.25;
                      double axisSpacing = itemSize * 0.035;
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
                                mainAxisSpacing: axisSpacing,
                                crossAxisSpacing: axisSpacing,
                              ),
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(borderRadius),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: outerAxisSpacing),
                  Container(
                    width: outerSizedBoxSize,
                    height: outerItemSize * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(outerBorderRadius),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              SizedBox(width: outerAxisSpacing * 2),
              Container(
                width: outerItemSize * 0.5,
                height: outerSizedBoxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(outerBorderRadius),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
