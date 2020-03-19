import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:m3alem/models/utilisateur.dart';
import 'package:m3alem/repository/repository.dart';

class UtilisateurRepository extends IRepositoryApi<Utilisateur> {
  static const _USER_LOGIN = "LOGIN";
  static const _USER_PASSEWORD = "PASSWORD";
  static const _KEY = "KEY";
  final storage = new FlutterSecureStorage();

  Future<Utilisateur> authenticate({
    @required String username,
    @required String password,
  }) async {
    try {
      final response =
          await http.get('$serverAdresse/login/$username/$password');

      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        // throw new Exception("Error while fetching data");
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      //user = User.fromJson(jsonData.first);
      Utilisateur utilisateur = Utilisateur.fromJson(data);
      return utilisateur;

      //return listUser.map((model) => User.fromJson(model)).toList().first;
    } catch (e) {
      return null;
    }
  }

  Future<Utilisateur> add(Utilisateur utilisateur) async {
    try {
      final response = await http.post(
        '$serverAdresse/utilisateurs',
        body: json.encode(utilisateur.toJson()),
        headers: headers,
      );

      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        // throw new Exception("Error while fetching data");
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      Utilisateur user = Utilisateur.fromJson(data);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<File> uploadPhotos(int cin, String codePhoto, File imageFile) async {
    try {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri =
          Uri.parse('$serverAdresse' + "/utilisateurs/photos/$cin/$codePhoto");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      /* request.fields["cin"] = cin.toString();
      request.fields["imageCode"] = codePhoto; */
      var response = await request.send();
      if (response.statusCode == 200) {
        return imageFile;
        /*  response.stream.transform(utf8.decoder).listen((value) {
         
        }); */

      }
      return null;
    } catch (e) {
      return null;
    }
  }

/*   Future<bool> isUserOldPasseWord(String password) async {
    try {
      String value = await storage.read(key: _KEY);
      if (value == null || value.isEmpty) {
        return false;
      }

      final result = await daoUser.getById(value);
      final user = User.fromJson(result);
      return user.password == password;
    } catch (e) {
      return false;
    }
  } */

/*   Future<void> deleteUser(String id) async {
    await storage.delete(key: _KEY);
   
  } */

  Future<void> persistUser(Utilisateur utilisateur) async {
    try {
      await storage.write(key: _KEY, value: json.encode(utilisateur.toJson()));

      //String value = await storage.read(key: _KEY);

    } catch (e) {
      //return null;
    }
    return;
  }

  Future<void> updateUser(Utilisateur utilisateur) async {
    try {
      final response = await http.put(
        '$serverAdresse/utilisateurs',
        body: json.encode(
          utilisateur.toJson(),
        ),
        headers: headers,
      );
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        return null;
      }
      return utilisateur;
    } catch (e) {
      return null;
    }
  }

  Future<Utilisateur> hasUser() async {
    String value = await storage.read(key: _KEY);
    if (value == null || value.isEmpty) {
      return null;
    }
    final utilisateur = Utilisateur.fromJson(json.decode(value));
    return utilisateur;
  }
}
