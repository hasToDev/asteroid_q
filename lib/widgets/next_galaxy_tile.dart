import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class NextGalaxyTile extends StatefulWidget {
  const NextGalaxyTile({
    super.key,
    required this.position,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.focusedIndex,
    required this.constraints,
    required this.onTapLeftClick,
  });

  final NextGalaxy position;
  final double width;
  final double height;
  final double borderRadius;
  final ValueNotifier<int> focusedIndex;
  final BoxConstraints constraints;
  final VoidCallback onTapLeftClick;

  @override
  State<NextGalaxyTile> createState() => _NextGalaxyTileState();
}

class _NextGalaxyTileState extends State<NextGalaxyTile> {
  late BoxConstraints currentConstraints;
  bool isSelected = false;
  Widget? cache;

  @override
  void initState() {
    currentConstraints = widget.constraints;
    isSelected = widget.position.id == widget.focusedIndex.value;
    super.initState();
  }

  void waitBeforeMouseDown() async {
    await Future.delayed(waitDuration);
    widget.onTapLeftClick.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        widget.focusedIndex.value = widget.position.id;
      },
      onExit: (_) {
        widget.focusedIndex.value = -1;
      },
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons != 1) return;

          if (widget.focusedIndex.value != widget.position.id) {
            widget.focusedIndex.value = widget.position.id;
            waitBeforeMouseDown();
            return;
          }

          widget.onTapLeftClick.call();
        },
        child: ValueListenableBuilder(
          valueListenable: widget.focusedIndex,
          builder: (context, selectedIndex, _) {
            bool sameConstraints = currentConstraints.isEqual(widget.constraints);
            bool stateChanges =
                widget.position.id == selectedIndex && !isSelected || widget.position.id != selectedIndex && isSelected;

            if (cache == null || !sameConstraints || stateChanges) {
              currentConstraints = widget.constraints;
              isSelected = widget.position.id == widget.focusedIndex.value;

              cache = Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  boxShadow: [
                    if (selectedIndex == widget.position.id)
                      const BoxShadow(
                        color: Colors.orange,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                  ],
                  border: selectedIndex == widget.position.id ? Border.all(color: Colors.blue, width: 2) : null,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                // child: Center(
                //   child: Text('${widget.index}'),
                // ),
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
