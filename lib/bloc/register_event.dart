
part of 'register_bloc.dart';
abstract class RegisterEvent extends Equatable {
   RegisterEvent();
}
class AddResgister extends RegisterEvent {
  final Utilisateur utilisateur;
  AddResgister({this.utilisateur});

  @override
  List get props => [this.utilisateur];
}