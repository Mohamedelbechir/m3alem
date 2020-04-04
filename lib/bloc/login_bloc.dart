import 'package:flutter/foundation.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/login_event.dart';
import 'package:m3alem/bloc/login_state.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:m3alem/utils/etat_inscription.dart';
import 'package:m3alem/utils/type_utilisateur.dart';

import 'authentification_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UtilisateurRepository utilisateurRepository;
  final AuthentificationBloc authentificationBloc;

  LoginBloc({
    @required this.utilisateurRepository,
    @required this.authentificationBloc,
  })  : assert(utilisateurRepository != null),
        assert(authentificationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final utilisateur = await utilisateurRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (utilisateur == null)
          yield LoginFailure(error: 'Login ou mot de passe incorrect');
        else if (utilisateur.typeUtilisateur == TypeUtilisateur.passager) {
          authentificationBloc.add(LoggedIn(utilisateur: utilisateur));
        }

        if (utilisateur.etatInscription == EtatInscription.enAttenteInscription)
          authentificationBloc.add(AccountIncomplet(utilisateur: utilisateur));
        else {
          authentificationBloc.add(LoggedIn(utilisateur: utilisateur));
          yield LoginInitial();
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
