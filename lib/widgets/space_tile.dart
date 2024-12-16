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
    required this.onTap,
  });

  final int index;
  final double spacing;
  final double borderRadius;
  final ValueNotifier<int> focusedIndex;
  final BoxConstraints constraints;
  final VoidCallback onTap;

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
      child: GestureDetector(
        onTap: widget.onTap,
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
                  color: Colors.grey[300],
                  boxShadow: [
                    if (selectedIndex == widget.index)
                      const BoxShadow(
                        color: Colors.orange,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                  ],
                  border: selectedIndex == widget.index ? Border.all(color: Colors.blue, width: 2) : null,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: Center(
                  child: Text('${widget.index}'),
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
