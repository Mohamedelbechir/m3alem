part of 'notifdriver_bloc.dart';

abstract class NotifDriverEvent extends Equatable {}

class PushNotif extends NotifDriverEvent {
  final Course course;

  PushNotif(this.course);

  @override
  String toString() => 'PushNotif(course: $course)';
}

class DisplayNofifDriver extends NotifDriverEvent {
  @override
  String toString() => "DisplayNofifDriver";
}

class ToContultedNotif extends NotifDriverEvent {
  @override
  String toString() => "ToContultedNotif";
}
