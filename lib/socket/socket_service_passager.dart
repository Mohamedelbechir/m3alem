import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/socket/socket.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketServicePassager extends SocketService {
  dynamic _passagerUnsubscribeWaitDriver;

  passagerSendRequest({Course course, OnSocketCourseResponse callback}) {
    /* pour être notifier en cas d'acceptation */
    _passagerUnsubscribeWaitDriver = client.subscribe(
      destination: "/course/accepted/${course.idPassager}",
      callback: (StompFrame frame) {
        final course = Course.fromJson(json.decode(frame.body));
        callback(course);
      },
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
