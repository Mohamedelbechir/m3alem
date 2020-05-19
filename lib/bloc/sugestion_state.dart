part of 'sugestion_bloc.dart';

abstract class SugestionState {
  SugestionState();
}

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
}
