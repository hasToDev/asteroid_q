import 'package:flutter/material.dart';
import '../core/models/leaderboard_entry.dart';
import '../core/services/auth_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final AuthService _authService = AuthService();
  List<LeaderboardEntry> _leaderboardEntries = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    // try {
    //   setState(() {
    //     _isLoading = true;
    //     _error = null;
    //   });
    //
    //   final entries = await _dbService.getLeaderboard();
    //   setState(() {
    //     _leaderboardEntries = entries;
    //     _isLoading = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     _error = 'Failed to load leaderboard: $e';
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_leaderboardEntries.isEmpty) {
      return const Center(
        child: Text('No scores yet. Be the first to submit!'),
      );
    }

    return ListView.builder(
      itemCount: _leaderboardEntries.length,
      itemBuilder: (context, index) {
        final entry = _leaderboardEntries[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(entry.playerName),
          subtitle: Text('Galaxy: ${entry.galaxy}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Distance: ${entry.distance}'),
              Text('Rotations: ${entry.rotate}'),
            ],
          ),
        );
      },
    );
  }
}
