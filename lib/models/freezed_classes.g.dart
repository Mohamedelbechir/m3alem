// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezed_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Utilisateur _$_$_UtilisateurFromJson(Map<String, dynamic> json) {
  return _$_Utilisateur(
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
    isOnLine: json['isOnLine'] as bool,
  );
}

Map<String, dynamic> _$_$_UtilisateurToJson(_$_Utilisateur instance) =>
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
      'isOnLine': instance.isOnLine,
    };

_$_Course _$_$_CourseFromJson(Map<String, dynamic> json) {
  return _$_Course(
    idPassager: json['idPassager'] as int,
    idDriver: json['idDriver'] as int,
    depart: json['depart'] as String,
    arrivee: json['arrivee'] as String,
    latLngDepart: json['latLngDepart'] as String,
    latLngArrivee: json['latLngArrivee'] as String,
    distance: (json['distance'] as num)?.toDouble(),
    prixCourse: (json['prixCourse'] as num)?.toDouble(),
    dateCourse: json['dateCourse'] == null
        ? null
        : DateTime.parse(json['dateCourse'] as String),
  );
}

Map<String, dynamic> _$_$_CourseToJson(_$_Course instance) => <String, dynamic>{
      'idPassager': instance.idPassager,
      'idDriver': instance.idDriver,
      'depart': instance.depart,
      'arrivee': instance.arrivee,
      'latLngDepart': instance.latLngDepart,
      'latLngArrivee': instance.latLngArrivee,
      'distance': instance.distance,
      'prixCourse': instance.prixCourse,
      'dateCourse': instance.dateCourse?.toIso8601String(),
    };

_$_ModelCardNotification _$_$_ModelCardNotificationFromJson(
    Map<String, dynamic> json) {
  return _$_ModelCardNotification(
    cin: json['cin'] as int,
    nom: json['nom'] as String,
    typeVoiture: json['typeVoiture'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    temps: (json['temps'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_ModelCardNotificationToJson(
        _$_ModelCardNotification instance) =>
    <String, dynamic>{
      'cin': instance.cin,
      'nom': instance.nom,
      'typeVoiture': instance.typeVoiture,
      'rating': instance.rating,
      'temps': instance.temps,
    };
