part of 'profil_bloc.dart';

abstract class ProfilEvent extends Equatable {
  ProfilEvent([List props = const []]) : super(props);
}

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
  UpdateLogin({this.login}) : super([login]);
  @override
  String toString() => 'update login';
}

class UpdateEmail extends ProfilEvent {
  String email;
  UpdateEmail({this.email}) : super([email]);
  @override
  String toString() => 'update email';
}

class UpdatePhoneNumber extends ProfilEvent {
  String number;
  UpdatePhoneNumber({this.number}) : super([number]);
  @override
  String toString() => 'update email';
}

class UpdatePasseWord extends ProfilEvent {
  String passWord;
  UpdatePasseWord({this.passWord}) : super([passWord]);
  @override
  String toString() => 'update passWord';
}

class UpdateProfil extends ProfilEvent {
  @override
  String toString() => 'Mise à jour de du profil';
}
