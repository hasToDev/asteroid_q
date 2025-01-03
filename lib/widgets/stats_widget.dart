import 'dart:typed_data';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final int score;
  final Color backgroundColor;

  const StatsWidget({
    super.key,
    required this.imageBytes,
    required this.score,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: buttonBlackShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white),
              child: Image.memory(
                imageBytes,
                height: getStatsImageSize(context),
                width: getStatsImageSize(context),
                fit: BoxFit.fitHeight,
                gaplessPlayback: true,
                isAntiAlias: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                score.toString(),
                style: getStatsStyle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
