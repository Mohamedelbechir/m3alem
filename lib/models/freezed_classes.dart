import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'freezed_classes.freezed.dart';
part 'freezed_classes.g.dart';

@freezed
abstract class Utilisateur with _$Utilisateur {
  const factory Utilisateur({
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
    bool isOnLine,
  }) = _Utilisateur;
  factory Utilisateur.fromJson(Map<String, dynamic> json) =>
      _$UtilisateurFromJson(json);
}

/* 
  classe Course
 */
@freezed
abstract class Course with _$Course {
  const factory Course({
    int idPassager,
    int idDriver,
    String depart,
    String arrivee,
    String latLngDepart,
    String latLngArrivee,
    double distance,
    double prixCourse,
    DateTime dateCourse,
  }) = _Course;
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}

@freezed
abstract class ModelCardNotification with _$ModelCardNotification {
  const factory ModelCardNotification({
    int cin,
    String nom,
    String typeVoiture,
    double rating,
    double temps,
  }) = _ModelCardNotification;
  factory ModelCardNotification.fromJson(Map<String, dynamic> json) =>
      _$ModelCardNotificationFromJson(json);
}
