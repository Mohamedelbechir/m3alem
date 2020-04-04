import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3alem/models/utilisateur.dart';

abstract class AuthentificationEvent extends Equatable {
  AuthentificationEvent([List props = const []]) : super(props);
  @override
  List get props => super.props;
}

class AppStarted extends AuthentificationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthentificationEvent {
  final Utilisateur utilisateur;

  LoggedIn({@required this.utilisateur}) : super([utilisateur]);

  @override
  String toString() => 'LoggedIn { token: $utilisateur }';
}

class LoggedOut extends AuthentificationEvent {
  @override
  String toString() => 'LoggedOut';
}

class AccountIncomplet extends AuthentificationEvent {
  final Utilisateur utilisateur;
  AccountIncomplet({@required this.utilisateur}) : super([utilisateur]);

  @override
  String toString() => "CountIncomplet";
}
class AccountCompleted extends AuthentificationEvent {
  @override
  String toString() => "AccountCompleted";
}
class DisplayAccountProgress extends AuthentificationEvent {

  @override
  String toString() => "DisplayAccountProgress";
}
