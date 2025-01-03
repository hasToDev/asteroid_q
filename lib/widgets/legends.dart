import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class Legends extends StatelessWidget {
  final String title;
  final List<Uint8List> icons;

  const Legends({
    super.key,
    required this.title,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Text(
            title,
            style: getStatsStyle(context)?.copyWith(
              color: nextGalaxyBlue,
            ),
          ),
        ),
        ...icons.map((icon) => Image.memory(
          icon,
          height: getStatsImageSize(context),
          width: getStatsImageSize(context),
          fit: BoxFit.fitHeight,
          gaplessPlayback: true,
          isAntiAlias: true,
        )),
      ],
    );
  }
}