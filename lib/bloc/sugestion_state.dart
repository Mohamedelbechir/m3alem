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
  SugestedDrivers({this.drivers = const []});
  @override
  String toString() => "SugestedDrivers";

  SugestedDrivers copyWith({
    List<ModelCardNotification> drivers,
  }) {
    return SugestedDrivers(
      drivers: drivers ?? this.drivers,
    );
  }
}
