import 'dart:convert';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardLargeProvider extends ChangeNotifier {
  List<LeaderboardEntry> entries = [];
  DateTime? lastUpdated;

  Future<void> fetch() async {
    if (lastUpdated != null && DateTime.now().difference(lastUpdated!).inSeconds < leaderboardUpdateWaitingTime) {
      return;
    }

    lastUpdated = DateTime.now();
    entries = await getIt<LeaderboardService>().getLeaderboard(GalaxySize.large);
    entries.sortByAll();
    await saveLeaderboard();
    notifyListeners();
  }

  Future<void> saveLeaderboard() async {
    final list = entries.map((entry) => entry.toJson()).toList();
    String jsonList = jsonEncode(list);
    await getIt<SharedPreferences>().setString(GalaxySize.large.sharedPreferenceKey, jsonList);
  }

  Future<void> loadLeaderboard() async {
    String jsonList = getIt<SharedPreferences>().getString(GalaxySize.large.sharedPreferenceKey) ?? '';
    if (jsonList.isEmpty) return;

    final list = jsonDecode(jsonList) as List;
    entries = list.map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> removeFromStorage() async {
    entries.clear();
    await getIt<SharedPreferences>().remove(GalaxySize.large.sharedPreferenceKey);
  }
}
