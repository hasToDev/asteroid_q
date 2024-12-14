import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int boxNumber = 17;
  late int itemCount;

  @override
  void initState() {
    super.initState();
    itemCount = boxNumber * boxNumber;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        child: GridView.builder(
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
    );
  }
}
