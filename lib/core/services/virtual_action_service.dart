import 'dart:async';
import 'package:asteroid_q/core/core.dart';

class VirtualActionService {
  static final VirtualActionService _instance = VirtualActionService._internal();

  factory VirtualActionService() => _instance;

  VirtualActionService._internal();

  final _messageController = StreamController<VirtualAction>.broadcast();

  Stream<VirtualAction> get messageStream => _messageController.stream;

  void sendAction(VirtualAction action) {
    _messageController.sink.add(action);
  }

  void dispose() {
    _messageController.close();
  }
}
