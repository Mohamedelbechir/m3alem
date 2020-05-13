part of 'sugestion_bloc.dart';

abstract class SugestionEvent extends Equatable {
  SugestionEvent();
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
