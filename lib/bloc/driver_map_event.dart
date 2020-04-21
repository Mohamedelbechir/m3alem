part of 'driver_map_bloc.dart';

abstract class DriverMapEvent extends Equatable {
  DriverMapEvent();

}

class DisplayDriverMap extends DriverMapEvent {}

class SwichDriverState extends DriverMapEvent {
  final bool isOnLine;

  SwichDriverState({this.isOnLine});
  @override
  String toString() => "SwichDriverState" + isOnLine.toString();
}

class DriverWaiting extends DriverMapEvent {
  @override
  String toString() => "DriverWaiting";
}
class DriverWaitingFail extends DriverMapEvent {
  @override
  String toString() => "DriverWaitingFail";
}
class DriverOnLine extends DriverMapEvent {
  @override
  String toString() => "DriverOnLine";
}
class DriverCourseNotification extends DriverMapEvent {
  final Course course;

  DriverCourseNotification(this.course);
  
  @override
  String toString() => "DriverCourseNotification";
}