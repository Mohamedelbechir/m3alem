import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/block/authentification_block.dart';
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
    // TODO: implement mapEventToState
  }
}
