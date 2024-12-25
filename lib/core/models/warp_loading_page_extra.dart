import 'package:asteroid_q/core/core.dart';

class WarpLoadingPageExtra {
  final int currentJetPositionIndex;
  final FighterJetDirection jetDirection;
  final TransitionDirection transitionDirection;

  WarpLoadingPageExtra({
    required this.currentJetPositionIndex,
    required this.jetDirection,
    required this.transitionDirection,
  });

  Map<String, dynamic> toJson() => {
        'currentJetPositionIndex': currentJetPositionIndex,
        'jetDirection': jetDirection.name, // Use .name to get the enum value as a String
        'transitionDirection': transitionDirection.name,
      };

  factory WarpLoadingPageExtra.fromJson(Map<String, dynamic> json) => WarpLoadingPageExtra(
        currentJetPositionIndex: json['currentJetPositionIndex'] as int,
        jetDirection: _jetDirectionFromString(json['jetDirection'] as String),
        transitionDirection: _transitionDirectionFromString(json['transitionDirection'] as String),
      );

  static FighterJetDirection _jetDirectionFromString(String value) {
    return FighterJetDirection.values.firstWhere((e) => e.name == value);
  }

  static TransitionDirection _transitionDirectionFromString(String value) {
    return TransitionDirection.values.firstWhere((e) => e.name == value);
  }
}
