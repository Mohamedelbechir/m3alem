// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) {
  return Utilisateur(
    cin: json['cin'] as int,
    nom: json['nom'] as String,
    prenom: json['prenom'] as String,
    dateNaissance: json['dateNaissance'] == null
        ? null
        : DateTime.parse(json['dateNaissance'] as String),
    dateDemande: json['dateDemande'] == null
        ? null
        : DateTime.parse(json['dateDemande'] as String),
    tel: json['tel'] as String,
    adresse: json['adresse'] as String,
    email: json['email'] as String,
    sexe: json['sexe'] as String,
    password: json['password'] as String,
    typeUtilisateur: json['typeUtilisateur'] as String,
    etatInscription: json['etatInscription'] as String,
    etatCompte: json['etatCompte'] as String,
  );
}

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'cin': instance.cin,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'dateNaissance': instance.dateNaissance?.toIso8601String(),
      'dateDemande': instance.dateDemande?.toIso8601String(),
      'tel': instance.tel,
      'adresse': instance.adresse,
      'email': instance.email,
      'sexe': instance.sexe,
      'password': instance.password,
      'typeUtilisateur': instance.typeUtilisateur,
      'etatInscription': instance.etatInscription,
      'etatCompte': instance.etatCompte,
    };
