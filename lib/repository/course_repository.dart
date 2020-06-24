import 'dart:convert';

import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/repository.dart';

import 'package:http/http.dart' as http;
import 'package:m3alem/utils/type_utilisateur.dart';

typedef OnSocketDriverRequestResponse = Function(
    List<ModelCardNotification> drivers);

class CourseRespository extends IRepositoryApi<Course> {
  Future<double> getPrixCourse(double distance) async {
    final response = await http.get('$serverAdresse/prix/$distance');

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      // throw new Exception("Error while fetching data");
      return null;
    }
    final data = json.decode(response.body);
    final prix = data['prix'] as double;
    return prix;
  }

  Future<List<ModelCardNotification>> getOnLineDriverForCourse() async {
    final response = await http.get('$serverAdresse/drivers-online');

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      // throw new Exception("Error while fetching data");
      return null;
    }
    List<dynamic> data = json.decode(response.body);
    List<ModelCardNotification> result =
        data.map((item) => ModelCardNotification.fromJson(item)).toList();

    return result;
  }

  Future<List<CourseHistorique>> getDriverCourses({int cin}) async {
    final response = await http.get(
        '$serverAdresse/courses/histories/$cin/${TypeUtilisateur.chauffeur}');

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      // throw new Exception("Error while fetching data");
      return null;
    }
    List<dynamic> data = json.decode(response.body);
    List<CourseHistorique> result =
        data.map((item) => CourseHistorique.fromJson(item)).toList();

    return result;
  }
}
