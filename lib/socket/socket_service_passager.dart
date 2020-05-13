import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'socket.dart';

class SocketServicePassager extends SocketService {
  dynamic _passagerUnsubscribeWaitDriver;

  passagerSendRequest({Course course, OnSocketPassagerCourseResponse callback}) {
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
