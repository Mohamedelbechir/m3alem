part of 'passager_map_bloc.dart';

abstract class PassagerMapEvent extends Equatable {
  PassagerMapEvent();
}

enum MarkerDragSourse { from, to }

class DisplayPassagerMap extends PassagerMapEvent {}

class LongPress extends PassagerMapEvent {
  final LatLng latLng;
  final MarkerDragSourse source;

  LongPress({this.source = MarkerDragSourse.to, this.latLng});

  @override
  List get props => [this.source, this.latLng];
}

class PassagerOnLineOk extends PassagerMapEvent {
  @override
  String toString() => "PassagerOnLineOk";
}

class PassagerOnLineKo extends PassagerMapEvent {
  @override
  String toString() => "PassagerOnLineKo";
}

class SendResquestToDriver extends PassagerMapEvent {
  final Course course;
  SendResquestToDriver(this.course);
  @override
  String toString() => "SendResquestToDriver";
}

class CommanderCourse extends PassagerMapEvent {
  final LatLng toLocation;
  final LatLng fromLocation;
  final String toText;
  final String fromText;

  CommanderCourse({
    @required this.toLocation,
    @required this.fromLocation,
    @required this.toText,
    @required this.fromText,
  });
  @override
  String toString() => "CommanderCourse";

  @override
  List get props => [toLocation, fromLocation, toText, fromText];
}
