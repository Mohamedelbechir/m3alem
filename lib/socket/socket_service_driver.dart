import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';

import 'socket.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketServiceDriver extends SocketService {
  dynamic _driverUnsubscribeWait;
  dynamic _driverUnsubscribeWaitPassager;
 
  driverSubscribForWait({OnSocketCourseResponse callback}) {
    _driverUnsubscribeWait = client.subscribe(
      destination: "/course/driver-waiting",
      callback: (StompFrame frame) {
        // Faire le decodage de la course (json => objet)
        Map<String, dynamic> data = json.decode(frame.body);
        final course = Course.fromJson(data);
        // appeler le callback avec les données
        callback(course);
      },
    );
  }

  acceptCourse(Course course) {
    client.send(
      destination: "/course/driver-accept",
      body: json.encode(course.toJson()),
    );
  }

  waitPassagerResponse(Course course, OnSocketResponse callback) {
    _driverUnsubscribeWaitPassager = client.subscribe(
      destination: "/course/accepted-by-passager",
      callback: callback,
    );
  }

  driverUnsubscribeForWaitLastPassager() {
    _driverUnsubscribeWaitPassager();
  }

  driverUnsubscribeForWait() {
    
    _driverUnsubscribeWait();
  }
}
