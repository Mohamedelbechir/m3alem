part of 'commander_course_bloc.dart';

abstract class CommanderCourseEvent extends Equatable {
  CommanderCourseEvent();
}

class DisplayCommandeCourse extends CommanderCourseEvent {
  @override
  String toString() => "DisplayCommandeCourse";
}



/* Pour envoyer le chauffeur selectionner dans la liste */
class SelectDriver extends CommanderCourseEvent {
  final Utilisateur driver;

  SelectDriver(this.driver);
  @override
  String toString() => "SelectDriver";
}

class UpdateFromMap extends CommanderCourseEvent {
  final LatLng from;
  final LatLng to;
  final String fromText;
  final String toText;

  UpdateFromMap({this.from, this.to, this.fromText, this.toText});
  @override
  String toString() => "UpdateFromMap";
}
