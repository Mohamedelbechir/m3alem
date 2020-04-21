
import 'package:m3alem/models/freezed_classes.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef OnSocketSuccess = Function(StompClient client, StompFrame frame);
typedef OnSocketResponse = Function(StompFrame frame);
typedef OnSocketCourseResponse = Function(Course frame);

abstract class SocketService {
  StompClient _client;
  final _headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  SocketService({
    OnSocketSuccess onSuccess,
    OnSocketResponse onError,
    errorSocket(dynamic value),
  }) {
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
    /* ouvir la connexion */
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
}
