import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:flutter/material.dart';

class DynamoDBService {
  final String region;
  final String accessKey;
  final String secretKey;
  final String sessionToken;
  final DynamoDB dynamoDB;

  DynamoDBService({
    required this.region,
    required this.accessKey,
    required this.secretKey,
    required this.sessionToken,
  }) : dynamoDB = DynamoDB(
          region: region,
          credentials: AwsClientCredentials(
            accessKey: accessKey,
            secretKey: secretKey,
            sessionToken: sessionToken,
          ),
        );

  Future<void> submitGameResult(
    String mapName,
    String playerName,
    int distance,
    int rotate,
    int refuel,
    int galaxy,
  ) async {
    try {
      await dynamoDB.putItem(
        tableName: mapName,
        item: {
          'player_name': AttributeValue(s: playerName),
          'distance': AttributeValue(n: distance.toString()),
          'rotate': AttributeValue(n: rotate.toString()),
          'refuel': AttributeValue(n: refuel.toString()),
          'galaxy': AttributeValue(n: galaxy.toString()),
          'timestamp': AttributeValue(n: DateTime.now().millisecondsSinceEpoch.toString()),
        },
      );
    } catch (e, s) {
      debugPrint('DynamoDBService submitGameResult $e\n$s');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard(String mapName) async {
    try {
      final response = await dynamoDB.scan(
        tableName: mapName,
        limit: 10,
      );

      final items = response.items ?? [];
      final leaderboard = items
          .map(
            (item) => {
              'playerName': item['player_name']?.s ?? '',
              'distance': int.tryParse(item['distance']?.n ?? '0'),
              'rotate': int.tryParse(item['rotate']?.n ?? '0'),
              'refuel': int.tryParse(item['refuel']?.n ?? '0'),
              'galaxy': int.tryParse(item['galaxy']?.n ?? '0'),
              'timestamp': int.tryParse(item['timestamp']?.n ?? '0'),
            },
          )
          .toList();

      // Sort by score in descending order
      leaderboard.sort((a, b) => (b['distance'] as int).compareTo(a['distance'] as int));
      return leaderboard;
    } catch (e, s) {
      debugPrint('DynamoDBService getLeaderboard $e\n$s');
      return [];
    }
  }
}
