part of 'commander_course_bloc.dart';

abstract class CommanderCourseEvent extends Equatable {
   CommanderCourseEvent();
}

class CommanderCourse extends CommanderCourseEvent {
  final LatLng toLocation;
  final LatLng fromLocation;
  final String toText;
  final String fromText;

  CommanderCourse({
    this.toLocation,
    this.fromLocation,
    this.toText,
    this.fromText,
  });
  @override
  String toString() => "CommanderCourse";

  @override
  List get props => [toLocation, fromLocation, toText, fromText];
}
class SelectDriver extends CommanderCourseEvent{
  final Utilisateur driver;

  SelectDriver(this.driver);
  @override
  String toString() => "SelectDriver";

}