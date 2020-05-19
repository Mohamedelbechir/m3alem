import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'package:flutter/foundation.dart';
import 'package:m3alem/models/freezed_classes.dart';

import 'socket.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketServiceDriver extends SocketService {
  dynamic _driverUnsubscribeWait;
  static final SocketServiceDriver _instance = SocketServiceDriver._internal();
  SocketServiceDriver._internal();
  factory SocketServiceDriver() => _instance;
  final _onLineSubject = BehaviorSubject<bool>();

  StreamSubscription<bool> listenDriverStatus(void Function(bool) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _onLineSubject.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void changeDriverStatus(bool newStatus) => _onLineSubject.add(newStatus);

  /* Le chafffeur écoute les notification des course */
  driverSubscribForWait(
      {@required OnSocketDriverCourseResponse callback, @required int cin}) {
    _driverUnsubscribeWait = client.subscribe(
      destination: "/course/driver-course-waiting/$cin",
      callback: (StompFrame frame) {
        final data = json.decode(frame.body);
        final course = Course.fromJson(data);
        callback(course);
      },
    );
  }

/* La chauffeur accepte une course et met à attendre une response de la part du passager */
  acceptCourse(Course course, {bool confirmation = true}) {
    client.send(
      destination: "/course/driver-course-confirmation",
      body: json.encode(course.toJson()
        ..addAll(<String, dynamic>{'confirmed': confirmation})),
    );
  }

  driverUnsubscribeForWait() {
    try {
      _driverUnsubscribeWait();
    } catch (_) {}
  }
}
