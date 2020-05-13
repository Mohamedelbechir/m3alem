import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef OnSocketSuccess = Function(StompClient client, StompFrame frame);
typedef OnSocketResponse = Function(StompFrame frame);
typedef OnSocketDriverCourseResponse = Function(Course course);
typedef OnSocketPassagerCourseResponse = Function({Course course, bool confirmed});
typedef OnSocketDriverRequestResponse = Function(
    List<ModelCardNotification> drivers);

abstract class SocketService {
  StompClient _client;
  bool _hasInit = false;
  final _headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  initSocket({
    OnSocketSuccess onSuccess,
    OnSocketResponse onError,
    errorSocket(dynamic value),
  }) {
    _hasInit = true;
    reset();
    _client = StompClient(
      config: StompConfig(
        // url: 'wss://echo.websocket.org',
        url: 'ws://192.168.43.186:8088/ws',
        stompConnectHeaders: _headers,
        webSocketConnectHeaders: _headers,
        onConnect: onSuccess,
        onStompError: onError,
        onUnhandledFrame: onError,
        onUnhandledMessage: onError,
        //onWebSocketError: errorSocket,
      ),
    );
    // ouvrir la connexion
    activate();
  }

  activate() {
    _client.activate();
  }

  reset() {
    if (_client != null) {
      _client.deactivate();
    }
  }

  disconnect() {
    _client.deactivate();
  }

  onConnectCallback(StompClient client, StompFrame connectFrame) {
    print("Connecion success");
  }

  StompClient get client => _client;
  bool get hastInit => _hasInit;
}
