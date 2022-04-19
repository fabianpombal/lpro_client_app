import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  String dato = '1235343';
  String _ip = '192.168.1.41';
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  SocketService() {
    this._initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  String get ip => this._ip;
  void set ip(String ip) {
    this._ip = ip;
    notifyListeners();
    _initConfig();
  }

  void _initConfig() {
    this._socket = IO.io(
        'http://$_ip:8001',
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'foo': 'bar'}).build());

    // socket.connect();

    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      socket.emit("mensaje", "test");
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', (data) {
      print(data);
      dato = data.toString();
      notifyListeners();
    });
  }
}
