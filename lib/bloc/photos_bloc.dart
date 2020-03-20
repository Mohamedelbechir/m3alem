import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/code_image.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final UtilisateurRepository utilisateurRepository;
  final AuthentificationBloc authentificationBloc;

  PhotosBloc({
    @required this.utilisateurRepository,
    @required this.authentificationBloc,
  });
  @override
  PhotosState get initialState => PhotosInitial();

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is AddPhoto)
      yield* _mapAddPhotoToState(event);
    else if (event is TestHasPhoto) {
      yield* _mapTestHasPhotoToState(event);
    }
  }

  Stream<PhotosState> _mapAddPhotoToState(AddPhoto event) async* {
    try {
      final file = await this.utilisateurRepository.uploadPhotos(
            cin: authentificationBloc.currentUser.cin,
            codePhoto: event.codePhoto,
            imageFile: event.file,
          );
      if (file != null) {
        if (event.codePhoto == CodePhoto.photoPermis) {
          yield PhotoAdded(message: "photo du permis ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        } else if (event.codePhoto == CodePhoto.photoAssurance) {
          yield PhotoAdded(message: "photo d'assurance ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        } else if (event.codePhoto == CodePhoto.photoCarteGrise) {
          yield PhotoAdded(
              message: "photo de la carte grise ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        } else if (event.codePhoto == CodePhoto.photoVoiture) {
          yield PhotoAdded(message: "photo de la voiture ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        } else if (event.codePhoto == CodePhoto.photoPieceIdentite) {
          yield PhotoAdded(
              message: "photo de la pièce d'identité ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        } else if (event.codePhoto == CodePhoto.photoIdentite) {
          yield PhotoAdded(
              message: "photo d'identité ajoutée avec succès!");
          yield PhotoLoaded(file: file);
        }
      } else
        yield PhotoNotAdded(message: "erreur lors de l'enregistrement");
    } catch (e) {}
  }

  Stream<PhotosState> _mapTestHasPhotoToState(TestHasPhoto event) async* {
    try {
      final Uint8List res = await utilisateurRepository.getPhoto(
        cin: authentificationBloc.currentUser.cin,
        codePhoto: event.codePhoto,
      );

      if (res == null) {
        yield PhotoHasNotUploaded();
      } else {
        yield PhotoHasUploaded(fileUint8List: res);
      }
    } catch (e) {}
  }
}
