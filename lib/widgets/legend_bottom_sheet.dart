import 'dart:typed_data';
import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class LegendsBottomSheet extends StatelessWidget {
  const LegendsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final legendItems = [
      _LegendItem(
        title: GalaxySize.large.apiPathName.toUpperCase(),
        description: 'Leaderboard for big map (Desktop)',
      ),
      _LegendItem(
        title: GalaxySize.small.apiPathName.toUpperCase(),
        description: 'Leaderboard for small map (Mobile)',
      ),
      _LegendItem(
        title: GalaxySize.medium.apiPathName.toUpperCase(),
        description: 'Leaderboard for medium map (Tablet)',
      ),
      const SizedBox(height: 16),
      const _LegendItem(
        title: 'No',
        description: 'Position in the leaderboard',
      ),
      const _LegendItem(
        title: 'Player',
        description: 'Name of the player',
      ),
      const _LegendItem(
        title: 'Age',
        description: 'Time since the score was achieved',
      ),
      const SizedBox(height: 16),
      _LegendItem(
        imageBytes: getIt<AssetByteService>().countDistance,
        description: 'Total distance traveled',
      ),
      _LegendItem(
        imageBytes: getIt<AssetByteService>().countRotation,
        description: 'Number of rotations performed',
      ),
      _LegendItem(
        imageBytes: getIt<AssetByteService>().countRefuel,
        description: 'Number of refuel actions',
      ),
      _LegendItem(
        imageBytes: getIt<AssetByteService>().countGalaxy,
        description: 'Number of galaxies visited',
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'LEGENDS',
                style: getLeaderboardTitleStyle(context),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: legendItems.length,
                itemBuilder: (context, index) => legendItems[index],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String? title;
  final Uint8List? imageBytes;
  final String description;

  const _LegendItem({
    this.title,
    this.imageBytes,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: getLegendItemSize(context),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    height: getStatsImageSize(context),
                    width: getStatsImageSize(context),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    isAntiAlias: true,
                  )
                : Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: getStatsStyle(context)?.copyWith(
                      color: nextGalaxyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          SizedBox(width: getLegendItemSeparatorSize(context)),
          Expanded(
            child: Text(
              description,
              style: getStatsStyle(context)?.copyWith(
                color: nextGalaxyBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
