part of 'passager_map_bloc.dart';

abstract class PassagerMapEvent extends Equatable {
  PassagerMapEvent();
}

class DisplayPassagerMap extends PassagerMapEvent {}

class LongPress extends PassagerMapEvent {
  final LatLng latLng;

  LongPress({this.latLng});

  @override
  List get props => [this.latLng];
}

class CommanderCourse extends PassagerMapEvent {
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

class PassagerOnLineOk extends PassagerMapEvent {
  @override
  String toString() => "PassagerOnLineOk";
}

class PassagerOnLineKo extends PassagerMapEvent {
  @override
  String toString() => "PassagerOnLineKo";
}
