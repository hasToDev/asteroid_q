import 'package:asteroid_q/core/core.dart';

class GamePlayPageExtra {
  final int jetPositionIndex;
  final FighterJetDirection jetDirection;
  final GalaxyData galaxyData;
  final TransitionDirection transitionDirection;

  GamePlayPageExtra({
    required this.jetPositionIndex,
    required this.jetDirection,
    required this.galaxyData,
    required this.transitionDirection,
  });

  Map<String, dynamic> toJson() => {
        'jetPositionIndex': jetPositionIndex,
        'jetDirection': jetDirection.name, // Use .name to get the enum value as a String
        'galaxyData': galaxyData.toJson(),
        'transitionDirection': transitionDirection.name,
      };

  factory GamePlayPageExtra.fromJson(Map<String, dynamic> json) => GamePlayPageExtra(
        jetPositionIndex: json['jetPositionIndex'] as int,
        jetDirection: _jetDirectionFromString(json['jetDirection'] as String),
        galaxyData: GalaxyData.fromJson(json['galaxyData'] as Map<String, dynamic>),
        transitionDirection: _transitionDirectionFromString(json['transitionDirection'] as String),
      );

  static FighterJetDirection _jetDirectionFromString(String value) {
    return FighterJetDirection.values.firstWhere((e) => e.name == value);
  }

  static TransitionDirection _transitionDirectionFromString(String value) {
    return TransitionDirection.values.firstWhere((e) => e.name == value);
  }
}
