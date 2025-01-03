import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class SpaceTile extends StatefulWidget {
  const SpaceTile({
    super.key,
    required this.index,
    required this.spacing,
    required this.borderRadius,
    required this.focusedIndex,
    required this.constraints,
    required this.onMouseDown,
  });

  final int index;
  final double spacing;
  final double borderRadius;
  final ValueNotifier<int> focusedIndex;
  final BoxConstraints constraints;
  final Function(PointerDownEvent) onMouseDown;

  @override
  State<SpaceTile> createState() => _SpaceTileState();
}

class _SpaceTileState extends State<SpaceTile> {
  late BoxConstraints currentConstraints;
  bool isSelected = false;
  Widget? cache;

  @override
  void initState() {
    currentConstraints = widget.constraints;
    isSelected = widget.index == widget.focusedIndex.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        widget.focusedIndex.value = widget.index;
      },
      child: Listener(
        onPointerDown: widget.onMouseDown,
        child: ValueListenableBuilder(
          valueListenable: widget.focusedIndex,
          builder: (context, selectedIndex, _) {
            bool sameConstraints = currentConstraints.isEqual(widget.constraints);
            bool stateChanges =
                widget.index == selectedIndex && !isSelected || widget.index != selectedIndex && isSelected;

            if (cache == null || !sameConstraints || stateChanges) {
              currentConstraints = widget.constraints;
              isSelected = widget.index == widget.focusedIndex.value;

              cache = Container(
                margin: EdgeInsets.all(widget.spacing),
                decoration: BoxDecoration(
                  color: selectedIndex == widget.index ? spaceTileOrange : spaceTileBlue,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              );

              return cache!;
            }

            return cache!;
          },
        ),
      ),
    );
  }
}
