part of 'sugestion_bloc.dart';

abstract class SugestionEvent extends Equatable {
  SugestionEvent();
}

class CommanderCourse extends SugestionEvent {
  final LatLng toLocation;
  final LatLng fromLocation;
  final String toText;
  final String fromText;
  final Set<Polyline> polyLines;

  CommanderCourse({
    @required this.toLocation,
    @required this.fromLocation,
    @required this.polyLines,
    @required this.toText,
    @required this.fromText,
  });
  @override
  String toString() => "CommanderCourse";

  @override
  List get props => [toLocation, fromLocation, toText, fromText, polyLines];
}

class SendResquestToDriver extends SugestionEvent {
  final Course course;
  SendResquestToDriver(this.course);
  @override
  String toString() => "SendResquestToDriver";
}

class AddDriverSugestion extends SugestionEvent {
  final List<ModelCardNotification> drivers;
  final Course course;

  AddDriverSugestion({this.drivers, this.course});

  @override
  String toString() => "AddDriverSugestion";
}

class ResetSugestion extends SugestionEvent {
  @override
  String toString() => "ResetSugestion";
}
