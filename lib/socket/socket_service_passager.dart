import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'socket.dart';

class SocketServicePassager extends SocketService {
  dynamic _passagerUnsubscribeWaitDriver;
  static final SocketServicePassager _instance =
      SocketServicePassager._internal();
  SocketServicePassager._internal();
  factory SocketServicePassager() => _instance;

  passagerSendRequest(
      {@required Course course,@required OnSocketPassagerCourseResponse callback}) {
    /* pour être notifier en cas d'acceptation */
    _passagerUnsubscribeWaitDriver = client.subscribe(
      destination:
          "/course/passager-request-response/${course.idPassager}", // rester à l'écoute
      callback: (StompFrame frame) {
        final data = json.decode(frame.body);
        final course = Course.fromJson(data);
        final confirmed = data["confirmed"];
        callback(course: course, confirmed: confirmed);
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

  void resetOldCourse() {
    try {
      _passagerUnsubscribeWaitDriver();
    } catch (e) {}
  }
}
