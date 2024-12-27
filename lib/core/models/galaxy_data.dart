import 'package:asteroid_q/core/core.dart';

class GalaxyData {
  final String name;
  final List<GameObjectPosition> items;

  GalaxyData({
    required this.name,
    required this.items,
  });

  factory GalaxyData.fromJson(Map<String, dynamic> json) {
    return GalaxyData(
      name: json['name'] as String,
      items: (json['items'] as List).map((item) => GameObjectPosition.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Create a new GalaxyData with an item removed
  // returns null if item not found
  GalaxyData? removeItemIfExists(int index, GameObjectType type) {
    final itemExists = items.any((item) => item.index == index && item.type == type);

    if (!itemExists) return null;

    return GalaxyData(
      name: name,
      items: items.where((item) => !(item.index == index && item.type == type)).toList(),
    );
  }
}

class GameObjectPosition {
  final int index;
  final GameObjectType type;

  GameObjectPosition({
    required this.index,
    required this.type,
  });

  factory GameObjectPosition.fromJson(Map<String, dynamic> json) {
    return GameObjectPosition(
      index: json['index'] as int,
      type: GameObjectType.values.firstWhere(
        (e) => e.toString() == 'ObjectType.${json['type']}',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'type': type.toString().split('.').last,
    };
  }
}
