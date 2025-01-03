import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class VirtualArrowButton extends StatelessWidget {
  const VirtualArrowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.up),
                child: Image.memory(
                  getIt<AssetByteService>().controlUp!,
                  height: getControlImageSize(context),
                  width: getControlImageSize(context),
                  fit: BoxFit.fitHeight,
                  gaplessPlayback: true,
                  isAntiAlias: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.left),
                child: Image.memory(
                  getIt<AssetByteService>().controlLeft!,
                  height: getControlImageSize(context),
                  width: getControlImageSize(context),
                  fit: BoxFit.fitHeight,
                  gaplessPlayback: true,
                  isAntiAlias: true,
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.down),
                child: Image.memory(
                  getIt<AssetByteService>().controlDown!,
                  height: getControlImageSize(context),
                  width: getControlImageSize(context),
                  fit: BoxFit.fitHeight,
                  gaplessPlayback: true,
                  isAntiAlias: true,
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => getIt<VirtualActionService>().sendAction(VirtualAction.right),
                child: Image.memory(
                  getIt<AssetByteService>().controlRight!,
                  height: getControlImageSize(context),
                  width: getControlImageSize(context),
                  fit: BoxFit.fitHeight,
                  gaplessPlayback: true,
                  isAntiAlias: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
