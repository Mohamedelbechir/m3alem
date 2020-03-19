import 'package:equatable/equatable.dart';

abstract class AuthentificationState extends Equatable {
  @override
  List get props => [];
  
}

class AuthentificationUninitialized extends AuthentificationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthentificationAuthenticated extends AuthentificationState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthentificationUnauthenticated extends AuthentificationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthentificationLoading extends AuthentificationState {
  @override
  String toString() => 'AuthenticationLoading';
}
class ImcompletedAccount extends AuthentificationState {
  @override
  String toString() => "ImcompletedAccount";
  
}
