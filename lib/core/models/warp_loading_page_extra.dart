import 'package:asteroid_q/core/core.dart';

class WarpLoadingPageExtra {
  final bool startNew;
  final int currentJetPositionIndex;
  final FighterJetDirection jetDirection;
  final TransitionDirection transitionDirection;
  final GalaxyCoordinates galaxyCoordinates;

  WarpLoadingPageExtra({
    this.startNew = false,
    required this.currentJetPositionIndex,
    required this.jetDirection,
    required this.transitionDirection,
    required this.galaxyCoordinates,
  });

  Map<String, dynamic> toJson() => {
        'startNew': startNew,
        'currentJetPositionIndex': currentJetPositionIndex,
        'jetDirection': jetDirection.name, // Use .name to get the enum value as a String
        'transitionDirection': transitionDirection.name,
        'galaxyCoordinates': galaxyCoordinates.toJson(),
      };

  factory WarpLoadingPageExtra.fromJson(Map<String, dynamic> json) => WarpLoadingPageExtra(
        startNew: json['startNew'] as bool,
        currentJetPositionIndex: json['currentJetPositionIndex'] as int,
        jetDirection: _jetDirectionFromString(json['jetDirection'] as String),
        transitionDirection: _transitionDirectionFromString(json['transitionDirection'] as String),
        galaxyCoordinates: GalaxyCoordinates.fromJson(json['galaxyCoordinates'] as Map<String, dynamic>),
      );

  static FighterJetDirection _jetDirectionFromString(String value) {
    return FighterJetDirection.values.firstWhere((e) => e.name == value);
  }

  static TransitionDirection _transitionDirectionFromString(String value) {
    return TransitionDirection.values.firstWhere((e) => e.name == value);
  }
}
