part of 'sugestion_bloc.dart';

abstract class SugestionState extends Equatable {}

class SugestionInitial extends SugestionState {}

class SugestionEmpty extends SugestionState {
  @override
  String toString() => "SugestionEmpty";
}

class SugestedDrivers extends SugestionState {
  final List<ModelCardNotification> drivers;
  final Course currentCourse;
  SugestedDrivers({this.drivers = const [], this.currentCourse});
  @override
  String toString() => "SugestedDrivers";

  SugestedDrivers copyWith({
    List<ModelCardNotification> drivers,
    Course currentCourse,
  }) {
    return SugestedDrivers(
      drivers: drivers ?? this.drivers,
      currentCourse: currentCourse ?? this.currentCourse,
    );
  }

  @override
  List get props => [this.currentCourse, drivers];
}

class RespondedRequest extends SugestionState {
  final bool confirmed;
  final Course course;

  RespondedRequest(this.course, this.confirmed);
  @override
  List get props => [this.course, this.confirmed];
}
