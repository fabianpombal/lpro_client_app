import 'package:flutter/cupertino.dart';

import '../MQTTManager.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  final List<String> _historyText = [];
  final Map<String, String> _historial = {};
  MQTTManager? _manager;
  int i = 0;

  void setReceivedText(String text, String topic) {
    i++;
    _receivedText = text;
    _historyText.add(_receivedText);
    topic = topic + i.toString();
    _historial[topic] = text;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void setManager(MQTTManager manager) {
    _manager = manager;
    notifyListeners();
  }

  void initializeManager() {
    _manager!.initializeMQTTClient();
    notifyListeners();
  }

  void connectManager() {
    _manager!.connect();
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  MQTTManager get getManager => _manager!;
  List<String> get getHistoryText => _historyText;
  Map<String, String> get getHistorial => _historial;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
