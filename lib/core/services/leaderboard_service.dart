import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:asteroid_q/core/core.dart';

class LeaderboardService {
  Future<void> postLeaderboard(GalaxySize map, LeaderboardEntry entry) async {
    try {
      RestOperation restOperation = Amplify.API.post(
        map.apiName,
        body: HttpPayload.json(entry.toJson()),
      );
      await restOperation.response;
    } on ApiException catch (e, s) {
      safePrint('LeaderboardService postLeaderboard $e\n$s');
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboard(GalaxySize map) async {
    try {
      RestOperation restOperation = Amplify.API.get(map.apiName);
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
}
