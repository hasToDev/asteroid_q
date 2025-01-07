import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:asteroid_q/core/core.dart';

class LeaderboardService {
  Future<void> postLeaderboard(GalaxySize map, LeaderboardEntry newEntry) async {
    try {
      List<LeaderboardEntry> currentEntries = await getMyLeaderboard(map, newEntry.playerName);
      if (currentEntries.isNotEmpty) {
        bool betterPerformance = newEntry.hasBetterPerformance(currentEntries.first);
        if (!betterPerformance) return;
      }

      RestOperation restOperation = Amplify.API.post(
        map.apiPathName,
        body: HttpPayload.json(newEntry.toJson()),
      );
      await restOperation.response;
    } on ApiException catch (e, s) {
      safePrint('LeaderboardService postLeaderboard $e\n$s');
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboard(GalaxySize map) async {
    try {
      RestOperation restOperation = Amplify.API.get(map.apiPathName);
      final response = await restOperation.response;
      return (jsonDecode(response.decodeBody()) as List)
          .cast<Map<String, dynamic>>()
          .map(LeaderboardEntry.fromJson)
          .toList();
    } on ApiException catch (e, s) {
      safePrint('LeaderboardService getLeaderboard $e\n$s');
      return [];
    }
  }

  Future<List<LeaderboardEntry>> getMyLeaderboard(GalaxySize map, String username) async {
    try {
      RestOperation restOperation = Amplify.API.get(
        'one${map.apiPathName}/$username',
      );
      final response = await restOperation.response;
      return (jsonDecode(response.decodeBody()) as List)
          .cast<Map<String, dynamic>>()
          .map(LeaderboardEntry.fromJson)
          .toList();
    } on ApiException catch (e, s) {
      safePrint('LeaderboardService getMyLeaderboard $e\n$s');
      return [];
    }
  }
}
