import 'package:equatable/equatable.dart';
import 'package:m3alem/models/freezed_classes.dart';

abstract class RegisterEvent extends Equatable {
   RegisterEvent();
}
class AddResgister extends RegisterEvent {
  final Utilisateur utilisateur;
  AddResgister({this.utilisateur});

  @override
  List get props => [this.utilisateur];
}