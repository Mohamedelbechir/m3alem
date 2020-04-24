part of 'commander_course_bloc.dart';

abstract class CommanderCourseState extends Equatable {
  CommanderCourseState();
}

class CommanderCourseInitial extends CommanderCourseState {
  @override
  List<Object> get props => [];
}

class CommanderCourseDisplayed extends CommanderCourseState {
  final LatLng from;
  final LatLng to;
  final String fromText;
  final String toText;

  CommanderCourseDisplayed({this.from, this.to, this.fromText, this.toText});
  @override
  String toString() => "CommanderCourseDisplayed";
  
  @override
  List<Object> get props => [this.from, this.to, this.fromText, this.toText];
}
