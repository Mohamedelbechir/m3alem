part of 'profil_bloc.dart';

abstract class ProfilState extends Equatable {
  ProfilState([List props = const []]) : super(props);
}

class ProfilInitial extends ProfilState {
  @override
  String toString() => 'LoginInitial';
}

class ProfilUpdating extends ProfilState {
  @override
  String toString() => 'Profil is updating';
}

class ProfilDispladed extends ProfilState {
  Utilisateur user;
  ProfilDispladed({@required this.user}) : super([user]);
  @override
  String toString() => 'Profil is display';
}

class ProfilUpdated extends ProfilState {
  Utilisateur user;
  final String message;
  ProfilUpdated({@required this.user, @required this.message}) : super([user]);
  @override
  String toString() => 'Profil is updated';
}
