import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/socket/socket.dart';

class SocketServicePassager extends SocketService {
  dynamic _passagerUnsubscribeWaitDriver;

  SocketServicePassager({
    OnSocketSuccess onSuccess,
    OnSocketResponse onError,
    errorSocket(dynamic value),
  }) : super(onSuccess: onSuccess, onError: onError, errorSocket: errorSocket);

  passagerSendRequest({Course course, OnSocketResponse callback}) {
    /* pour être notifier en cas d'acceptation */
    _passagerUnsubscribeWaitDriver = client.subscribe(
      destination: "/course/accepted/${course.idPassager}",
      callback: callback,
    );
    /* Faire la commande */
    client.send(
      destination: '/course/passager-request',
      body: json.encode(course.toJson()),
    );
  }

  passagerUnsubscribeForWaitDriver() {
    _passagerUnsubscribeWaitDriver();
  }

  validerCourse(Course course) {
    client.send(
      destination: "/course/passager-validate",
      body: json.encode(course.toJson()),
    );
  }
}
