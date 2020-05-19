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

class ToConsultedNotif extends NotifDriverEvent {
  @override
  String toString() => "ToContultedNotif";
}

class AccepterCourse extends NotifDriverEvent {
  final Course course;

  AccepterCourse(this.course);

  @override
  String toString() => "AccepterCourse";
}
