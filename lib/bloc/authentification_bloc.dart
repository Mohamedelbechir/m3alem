import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/bloc/authentification_state.dart';
import 'package:m3alem/models/utilisateur.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  final UtilisateurRepository utilisateurRepository;
  static Utilisateur _currentUtilisateur;

  AuthentificationBloc({@required this.utilisateurRepository})
      : assert(utilisateurRepository != null);
  @override
  AuthentificationState get initialState => AuthentificationUninitialized();
 Utilisateur  get currentUser => AuthentificationBloc._currentUtilisateur;
  @override
  Stream<AuthentificationState> mapEventToState(
      AuthentificationEvent event) async* {
    if (event is AppStarted) {
      final Utilisateur hasToken = await utilisateurRepository.hasUser();

      if (hasToken != null) {
        _currentUtilisateur = hasToken;
        yield AuthentificationAuthenticated();
      } else {
        yield AuthentificationUnauthenticated();
      }
    } else if (event is LoggedIn) {
      _currentUtilisateur = event.utilisateur;
      yield AuthentificationLoading();
      /// await utilisateurRepository.persistUser(event.utilisateur);
      yield AuthentificationAuthenticated();
    } else if (event is LoggedOut) {
      yield AuthentificationLoading();
      //await userRepository.deleteToken();
      //await utilisateurRepository.deleteUser(_currentUtilisateur.cin);
      yield AuthentificationUnauthenticated();
    } else if (event is AccountIncomplet) {
      yield* _mapAccountIncompletToState(event);
    }
  }

  Stream<AuthentificationState> _mapAccountIncompletToState(event) async* {
     _currentUtilisateur = event.utilisateur;
    yield ImcompletedAccount();
    /*  try {
      final user = await this
          .utilisateurRepository
          .add((event as AddResgister).utilisateur);
      if (user != null)
        yield RegisterSuccess(utilisateur: user);
      else
        yield RegisterError(message: "Echec lors de votre inscription");
    } catch (_) {
      yield RegisterError(message: "Echec lors de votre inscription");
    } */
  }
}
