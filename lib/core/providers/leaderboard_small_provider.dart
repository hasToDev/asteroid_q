import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';

class LeaderboardSmallProvider extends ChangeNotifier {
  List<LeaderboardEntry> entries = [];
  DateTime? lastUpdated;

  Future<void> fetch() async {
    if (lastUpdated != null && DateTime.now().difference(lastUpdated!).inSeconds < leaderboardUpdateWaitingTime) {
      return;
    }

    lastUpdated = DateTime.now();
    entries = await getIt<LeaderboardService>().getLeaderboard(GalaxySize.small);
    entries.sortByAll();
    notifyListeners();
  }
}
