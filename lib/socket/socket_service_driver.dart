import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';

import 'socket.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketServiceDriver extends SocketService {
  dynamic _driverUnsubscribeWait;
  /* Le chafffeur écoute les notification des course */
  driverSubscribForWait({OnSocketDriverCourseResponse callback}) {
    _driverUnsubscribeWait = client.subscribe(
      destination: "/course/driver-course-waiting",
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
    _driverUnsubscribeWait();
  }
}
