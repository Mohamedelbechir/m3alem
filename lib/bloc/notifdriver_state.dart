part of 'notifdriver_bloc.dart';

abstract class NotifDriverState extends Equatable {}

class NotifDriverInitial extends NotifDriverState {
  @override
  String toString() => "NotifDriverInitial";
}

class NotifLoaded extends NotifDriverState {
  final List<Course> courses;
  final bool consulted;

  NotifLoaded({this.courses = const [], this.consulted = false});

  @override
  List get props => [courses, consulted];

  NotifLoaded copyWith({
    List<Course> courses,
    bool consulted,
  }) {
    return NotifLoaded(
      courses: courses ?? this.courses,
      consulted: consulted ?? this.consulted,
    );
  }
}

class NotifEmpty extends NotifDriverState {
  @override
  String toString() => "NotifEmpty";
}
