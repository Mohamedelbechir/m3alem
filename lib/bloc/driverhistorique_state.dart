part of 'driverhistorique_bloc.dart';

abstract class DriverhistoriqueState extends Equatable {
  DriverhistoriqueState();
}

class DriverhistoriqueInitial extends DriverhistoriqueState {
  @override
  List<Object> get props => [];
}

class DriverhistoriqueLoaded extends DriverhistoriqueState {
  final List<CourseHistorique> courses;

  DriverhistoriqueLoaded({@required this.courses = const []});
  @override
  List<Object> get props => [courses];
  @override
  String toString() => "DriverhistoriqueLoaded";
}
