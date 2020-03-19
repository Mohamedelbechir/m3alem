

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'utilisateur.g.dart';

@JsonSerializable()
class Utilisateur extends Equatable {
  int cin;
  String nom;
  String prenom;
  DateTime dateNaissance;
  DateTime dateDemande;
  String tel;
  String adresse;
  String email;
  String sexe;
  String password;
  String typeUtilisateur;
  String etatInscription;
  String etatCompte;

  

  factory Utilisateur.fromJson(Map<String, dynamic> json) => _$UtilisateurFromJson(json);
  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
  Utilisateur({
    this.cin,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.dateDemande,
    this.tel,
    this.adresse,
    this.email,
    this.sexe,
    this.password,
    this.typeUtilisateur,
    this.etatInscription,
    this.etatCompte,
  });



  Utilisateur copyWith({
    int cin,
    String nom,
    String prenom,
    DateTime dateNaissance,
    DateTime dateDemande,
    String tel,
    String adresse,
    String email,
    String sexe,
    String password,
    String typeUtilisateur,
    String etatInscription,
    String etatCompte,
  }) {
    return Utilisateur(
      cin: cin ?? this.cin,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      dateDemande: dateDemande ?? this.dateDemande,
      tel: tel ?? this.tel,
      adresse: adresse ?? this.adresse,
      email: email ?? this.email,
      sexe: sexe ?? this.sexe,
      password: password ?? this.password,
      typeUtilisateur: typeUtilisateur ?? this.typeUtilisateur,
      etatInscription: etatInscription ?? this.etatInscription,
      etatCompte: etatCompte ?? this.etatCompte,
    );
  }

}
