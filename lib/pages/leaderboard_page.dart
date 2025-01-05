import 'dart:typed_data';

import 'package:asteroid_q/core/core.dart';
import 'package:asteroid_q/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({
    super.key,
  });

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLeaderboards();
  }

  void _loadLeaderboards() async {
    await getIt<LeaderboardLargeProvider>().fetch();
    await getIt<LeaderboardSmallProvider>().fetch();
    await getIt<LeaderboardMediumProvider>().fetch();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'LEADERBOARD',
                      style: getLeaderboardTitleStyle(context),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: AppElevatedButton(
                    title: 'Back',
                    onPressed: () => context.go(AppPaths.home),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: AppElevatedButton(
                    title: 'Legends',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const LegendsBottomSheet(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: GalaxySize.large.apiPathName.toUpperCase()),
              Tab(text: GalaxySize.small.apiPathName.toUpperCase()),
              Tab(text: GalaxySize.medium.apiPathName.toUpperCase()),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Consumer<LeaderboardLargeProvider>(builder: (BuildContext context, leaderboard, Widget? _) {
                  return _buildLeaderboardTab(leaderboard.entries);
                }),
                Consumer<LeaderboardSmallProvider>(builder: (BuildContext context, leaderboard, Widget? _) {
                  return _buildLeaderboardTab(leaderboard.entries);
                }),
                Consumer<LeaderboardMediumProvider>(builder: (BuildContext context, leaderboard, Widget? _) {
                  return _buildLeaderboardTab(leaderboard.entries);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Image.memory(
            getIt<AssetByteService>().imageRANK!,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            isAntiAlias: true,
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _buildLeaderboardRow(index + 1, entries[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildHeaderCell('No', flex: 1),
          _buildHeaderCell('Player', flex: 2),
          _buildHeaderCell('', flex: 1, imageByte: getIt<AssetByteService>().countDistance!),
          _buildHeaderCell('', flex: 1, imageByte: getIt<AssetByteService>().countRotation!),
          _buildHeaderCell('', flex: 1, imageByte: getIt<AssetByteService>().countRefuel!),
          _buildHeaderCell('', flex: 1, imageByte: getIt<AssetByteService>().countGalaxy!),
          _buildHeaderCell('Age', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    Uint8List? imageByte,
  }) {
    return Expanded(
      flex: flex,
      child: imageByte != null
          ? Image.memory(
              imageByte,
              height: getStatsImageSize(context) * 0.9,
              width: getStatsImageSize(context) * 0.9,
              fit: BoxFit.fitHeight,
              gaplessPlayback: true,
              isAntiAlias: true,
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              style: getStatsStyle(context)?.copyWith(
                color: nextGalaxyBlue,
              ),
            ),
    );
  }

  Widget _buildLeaderboardRow(int position, LeaderboardEntry entry) {
    String rankAge = GetTimeAgo.parse(entry.timestamp);
    if (!rankAge.contains('ago')) {
      Duration now = DateTime.now().difference(entry.timestamp);
      rankAge = '${now.inDays} days';
    }
    rankAge = rankAge.replaceAll('ago', '').trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '$position',
            textAlign: TextAlign.center,
            style: getLeaderboardRowStyle(context),
          )),
          Expanded(
              flex: 2,
              child: Text(
                entry.playerName,
                textAlign: TextAlign.center,
                style: getLeaderboardRowStyle(context),
              )),
          Expanded(
              child: Text(
            '${entry.distance}',
            textAlign: TextAlign.center,
            style: getLeaderboardRowStyle(context),
          )),
          Expanded(
              child: Text(
            '${entry.rotate}',
            textAlign: TextAlign.center,
            style: getLeaderboardRowStyle(context),
          )),
          Expanded(
              child: Text(
            '${entry.refuel}',
            textAlign: TextAlign.center,
            style: getLeaderboardRowStyle(context),
          )),
          Expanded(
              child: Text(
            '${entry.galaxy}',
            textAlign: TextAlign.center,
            style: getLeaderboardRowStyle(context),
          )),
          Expanded(
              flex: 2,
              child: Text(
                rankAge,
                textAlign: TextAlign.center,
                style: getLeaderboardRowStyle(context),
              )),
        ],
      ),
    );
  }
}
