part of 'sugestion_bloc.dart';

abstract class SugestionState extends Equatable {
  SugestionState();
}

class SugestionInitial extends SugestionState {
  @override
  List<Object> get props => [];
}

class SugestedDrivers extends SugestionState {
  final List<Utilisateur> drivers;
  SugestedDrivers(this.drivers);
  @override
  String toString() => "SugestedDrivers";
}
