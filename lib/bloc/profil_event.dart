part of 'profil_bloc.dart';

abstract class ProfilEvent extends Equatable {}

class DisplayProfil extends ProfilEvent {
  @override
  String toString() => 'Ouverture du profil';
}

class UpdateFullName extends ProfilEvent {
  final String nom;
  final String prenom;

  UpdateFullName({this.nom, this.prenom});

  String toString() => 'update full name';
}

class UpdateLogin extends ProfilEvent {
  String login;
  UpdateLogin({this.login});
  @override
  String toString() => 'update login';
}

class UpdateEmail extends ProfilEvent {
  String email;
  UpdateEmail({this.email});
  @override
  String toString() => 'update email';
}

class UpdatePhoneNumber extends ProfilEvent {
  String number;
  UpdatePhoneNumber({this.number});
  @override
  String toString() => 'update email';
}

class UpdatePasseWord extends ProfilEvent {
  String passWord;
  UpdatePasseWord({this.passWord});
  @override
  String toString() => 'update passWord';
}

class UpdateCreditCard extends ProfilEvent {
  final MyCreditCardModel model;

  UpdateCreditCard(this.model);
  @override
  String toString() => 'Mise à jour de du profil';
}
