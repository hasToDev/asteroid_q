import 'dart:convert';

import 'package:asteroid_q/core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await saveLeaderboard();
    notifyListeners();
  }

  Future<void> saveLeaderboard() async {
    final list = entries.map((entry) => entry.toJson()).toList();
    String jsonList = jsonEncode(list);
    await getIt<SharedPreferences>().setString(GalaxySize.small.sharedPreferenceKey, jsonList);
  }

  Future<void> loadLeaderboard() async {
    try {
      String jsonList = getIt<SharedPreferences>().getString(GalaxySize.small.sharedPreferenceKey) ?? '';
      if (jsonList.isEmpty) return;

      final list = jsonDecode(jsonList) as List;
      entries = list.map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e, s) {
      debugPrint('LeaderboardSmallProvider loadLeaderboard $e\n$s');
      // Handle any JSON decode errors or type casting errors and optionally clear corrupted data
      // await removeFromStorage();
    }
  }

  Future<void> removeFromStorage() async {
    entries.clear();
    await getIt<SharedPreferences>().remove(GalaxySize.small.sharedPreferenceKey);
  }
}
