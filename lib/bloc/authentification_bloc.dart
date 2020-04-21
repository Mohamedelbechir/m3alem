import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/bloc/authentification_state.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/etat_inscription.dart';
import 'package:m3alem/utils/type_utilisateur.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  UtilisateurRepository _utilisateurRepository;
  static Utilisateur _currentUtilisateur;

  Map<String, String> _map = {
    EtatInscription.accepterInscription:
        "Votre demande d'hadhesion a été acceptée !",
    EtatInscription.enAttenteInscription:
        "Votre demande d'hadhesion est encour de traitement",
    EtatInscription.refuserInscription:
        "Désoler votre demande d'hadhesion a pas été acceptée"
  };

  AuthentificationBloc({@required UtilisateurRepository utilisateurRepository})
      : assert(utilisateurRepository != null) {
    _utilisateurRepository = utilisateurRepository;
  }
  @override
  AuthentificationState get initialState => AuthentificationUninitialized();
  Utilisateur get currentUser => AuthentificationBloc._currentUtilisateur;
  @override
  Stream<AuthentificationState> mapEventToState(
      AuthentificationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState(event);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState(event);
    } else if (event is AccountIncomplet) {
      yield* _mapAccountIncompletToState(event);
    } else if (event is AccountCompleted) {
      yield* _mapToHomeState();
    } else if (event is DisplayAccountProgress) {
      yield* _mapDisplayAccountProgressToState(event: event);
    }
  }

  Stream<AuthentificationState> _mapLoggedOutToState(LoggedOut event) async* {
    yield AuthentificationLoading();
    //await userRepository.deleteToken();
    //await utilisateurRepository.deleteUser(_currentUtilisateur.cin);
    yield AuthentificationUnauthenticated();
  }

  Stream<AuthentificationState> _mapLoggedInToState(LoggedIn event) async* {
    _currentUtilisateur = event.utilisateur;
    yield AuthentificationLoading();

    /// await utilisateurRepository.persistUser(event.utilisateur);
    yield* _mapToHomeState();
  }

  Stream<AuthentificationState> _mapAppStartedToState(AppStarted event) async* {
    final Utilisateur hasToken = await _utilisateurRepository.hasUser();

    if (hasToken != null) {
      _currentUtilisateur = hasToken;
      yield* _mapToHomeState();
    } else {
      yield AuthentificationUnauthenticated();
    }
  }

  Stream<AuthentificationState> _mapToHomeState() async* {
    if (_currentUtilisateur.typeUtilisateur == TypeUtilisateur.passager)
      yield AuthentificationAuthenticated();
    else if (_currentUtilisateur.typeUtilisateur == TypeUtilisateur.chauffeur) {
      if (_currentUtilisateur.etatInscription ==
          EtatInscription.accepterInscription) {
        yield AuthentificationAuthenticatedChauffeur();
      } else
        yield* _mapDisplayAccountProgressToState();
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

  Stream<AuthentificationState> _mapDisplayAccountProgressToState(
      {DisplayAccountProgress event}) async* {
    yield AccountProgress(
        etat: currentUser.etatInscription,
        message: _map[currentUser.etatInscription]);
  }

  setCurrentUSer(Utilisateur utilisateur) {
    _currentUtilisateur = utilisateur;
  }
}
