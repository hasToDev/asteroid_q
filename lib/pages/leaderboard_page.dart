import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({
    super.key,
  });

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardEntry> leaderboard = [];

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    try {
      final leaderboardData = await getIt<DynamoDBService>().getLeaderboard('mapName');
      leaderboard = leaderboardData.map((entry) => LeaderboardEntry.fromMap(entry)).toList();
    } catch (e, s) {
      debugPrint('LeaderboardPage loadLeaderboard $e\n$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Builder(builder: (context) {
        if (leaderboard.isEmpty) return const SizedBox();
        return ListView.builder(
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            final entry = leaderboard[index];
            return ListTile(
              leading: Text('#${index + 1}'),
              title: Text(entry.playerName),
              trailing: Text(entry.galaxy.toString()),
            );
          },
        );
      }),
    );
  }
}
