import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'legends.dart';

class GameLeftPanel extends StatelessWidget {
  final double horizontalSpace;
  final VoidCallback onTap;

  const GameLeftPanel({
    super.key,
    required this.horizontalSpace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Image.memory(
                getIt<AssetByteService>().imageEXIT!,
                height: getStatsImageSize(context) * 2,
                width: getStatsImageSize(context) * 2,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
                isAntiAlias: true,
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        Legends(
          title: 'Move',
          icons: [getIt<AssetByteService>().legendEnter!, getIt<AssetByteService>().legendMouseLeft!],
        ),
        Legends(
          title: 'Shoot',
          icons: [
            getIt<AssetByteService>().legendSpace!,
            getIt<AssetByteService>().legendMouseRight!,
          ],
        ),
        Legends(
          title: 'Refuel',
          icons: [getIt<AssetByteService>().legendR!, getIt<AssetByteService>().legendMouseMiddle!],
        ),
        Legends(
          title: 'Select',
          icons: [
            getIt<AssetByteService>().legendArrowLeft!,
            getIt<AssetByteService>().legendArrowRight!,
            getIt<AssetByteService>().legendArrowUp!,
            getIt<AssetByteService>().legendArrowDown!,
          ],
        ),
        SizedBox(height: 4, width: horizontalSpace / 2),
      ],
    );
  }
}
