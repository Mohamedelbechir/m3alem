import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';

part 'profil_event.dart';
part 'profil_state.dart';

class ProfilBloc extends Bloc<ProfilEvent, ProfilState> {
  final UtilisateurRepository utilisateurRepository;
  final AuthentificationBloc authentificationBloc;
  ProfilBloc({
    @required this.utilisateurRepository,
    @required this.authentificationBloc,
  });

  @override
  ProfilState get initialState => ProfilInitial();

  @override
  Stream<ProfilState> mapEventToState(ProfilEvent event) async* {
    if (event is UpdateFullName) {
      final user = _currentUser.copyWith(nom: event.nom, prenom: event.prenom);
      await utilisateurRepository.updateUser(user);
      authentificationBloc.setCurrentUSer(user);
      yield ProfilUpdated(
          user: user, message: "Notre nom est mis à jour avec succès");
      yield ProfilDispladed(user: _currentUser);
    } else if (event is UpdateEmail) {
      final user = _currentUser.copyWith(email: event.email);
      await utilisateurRepository.updateUser(user);
      await authentificationBloc.setCurrentUSer(user);
      yield ProfilDispladed(user: user);
    } else if (event is UpdatePhoneNumber) {
      final user = _currentUser.copyWith(tel: event.number);
      await utilisateurRepository.updateUser(user);
      await authentificationBloc.setCurrentUSer(user);
      yield ProfilDispladed(user: user);
    } else if (event is UpdatePasseWord) {
      final user = _currentUser.copyWith(tel: event.passWord);
      await utilisateurRepository.updateUser(user);
      await authentificationBloc.setCurrentUSer(user);
      yield ProfilDispladed(user: user);
    } else if (event is DisplayProfil) {
      // final user = await utilisateurRepository.hasUser();
      yield ProfilDispladed(user: _currentUser);
    }
  }

  Utilisateur get _currentUser => authentificationBloc.currentUser;
}
