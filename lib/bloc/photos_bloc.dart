import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';

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
    if (event is AddPhoto) yield* _mapAddPhotoToState(event);
  }

  Stream<PhotosState> _mapAddPhotoToState(event) async* {
    final e = (event as AddPhoto);
    try {
      final file = await this.utilisateurRepository.uploadPhotos(
            authentificationBloc.currentUser.cin,
            e.codePhoto,
            e.file,
          );
      if (file != null)
        yield PhotoAdded();
      else
        PhotoNotAdded(message: "erreur lors de l'enregistrement");
    } catch (e) {}
  }
}
