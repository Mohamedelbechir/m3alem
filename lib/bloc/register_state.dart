import 'package:equatable/equatable.dart';
import 'package:m3alem/models/utilisateur.dart';

abstract class RegisterState extends Equatable {
  RegisterState();
  @override
  List get props => [];
}

class RegisterFormLoad extends RegisterState {
  
}
class RegisterSuccess extends RegisterState {
  final Utilisateur utilisateur;
  RegisterSuccess({this.utilisateur});

  @override
  List get props => [this.utilisateur];

  @override 
  String toString() => 'RegisterSuccesd { utilisateur : $utilisateur }';
  
}
class RegisterError extends RegisterState{
  final String message;
  RegisterError({this.message});
  @override
  // TODO: implement props
  List get props => [this.message];
  
}