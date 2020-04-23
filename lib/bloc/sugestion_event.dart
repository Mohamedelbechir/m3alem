part of 'sugestion_bloc.dart';

abstract class SugestionEvent extends Equatable {
  SugestionEvent();
}

class AddDriverSugestion extends SugestionEvent {
  final Utilisateur driver;

  AddDriverSugestion(this.driver);
  @override
  String toString() => "AddDriverSugestion";
}
