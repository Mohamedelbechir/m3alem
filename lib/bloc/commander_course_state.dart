part of 'commander_course_bloc.dart';

abstract class CommanderCourseState extends Equatable {
   CommanderCourseState();
}

class CommanderCourseInitial extends CommanderCourseState {
  @override
  List<Object> get props => [];
}
class DisplayedCommander extends CommanderCourseState {
  
  @override
  List<Object> get props => [];
}

class DriverSugested extends CommanderCourseState {
  final List<Utilisateur> drivers;

  DriverSugested({this.drivers = const []});

  @override
  String toString() {
    return "DriverSugested";
  }
}
