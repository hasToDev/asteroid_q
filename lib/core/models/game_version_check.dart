import 'package:flutter/material.dart';

class GameVersionCheck {
  GameVersionCheck({
    required this.major,
    required this.minor,
    required this.patch,
    required this.buildNumber,
  });

  late int major;
  late int minor;
  late int patch;
  late int buildNumber;

  factory GameVersionCheck.fromJson(Map<String, dynamic> json) {
    if (json['version'] == null) {
      return GameVersionCheck(major: 0, minor: 0, patch: 0, buildNumber: 0);
    }
    return GameVersionCheck(
      major: json['version']['major'] ?? 0,
      minor: json['version']['minor'] ?? 0,
      patch: json['version']['patch'] ?? 0,
      buildNumber: json['version']['buildNumber'] ?? 0,
    );
  }

  bool isLatestVersion(String currentVersionString) {
    try {
      final parts = currentVersionString.split('.');
      final majorString = int.parse(parts[0]);
      final minorString = int.parse(parts[1]);

      final patchBuild = parts[2].split('+');
      final patchString = int.parse(patchBuild[0]);
      final buildString = patchBuild.length > 1 ? int.parse(patchBuild[1]) : 0;

      if (major > majorString) {
        return true;
      } else if (major == majorString && minor > minorString) {
        return true;
      } else if (major == majorString && minor == minorString && patch > patchString) {
        return true;
      } else if (major == majorString && minor == minorString && patch == patchString && buildNumber > buildString) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('GameVersionCheck isLatestVersion error $e');
      return false;
    }
  }

  @override
  String toString() {
    if (buildNumber != 0) return "version $major.$minor.$patch+$buildNumber";
    return "version $major.$minor.$patch";
  }
}
