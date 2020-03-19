import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/bloc/register_event.dart';
import 'package:m3alem/bloc/register_state.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/type_utilisateur.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UtilisateurRepository utilisateurRepository;
  final AuthentificationBloc authentificationBloc;
  RegisterBloc({
    @required this.utilisateurRepository,
    @required this.authentificationBloc,
  }) : assert(utilisateurRepository != null);
  @override
  RegisterState get initialState => RegisterFormLoad();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is AddResgister) yield* _mapAddUserToState(event);
  }

  Stream<RegisterState> _mapAddUserToState(event) async* {
    try {
      final user = await this
          .utilisateurRepository
          .add((event as AddResgister).utilisateur);
      if (user != null) {
        yield RegisterSuccess(utilisateur: user);
        if (user.typeUtilisateur == TypeUtilisateur.chauffeur)
          authentificationBloc.dispatch(AccountIncomplet(utilisateur: user));
      } else
        yield RegisterError(message: "Echec lors de votre inscription");
    } catch (_) {
      yield RegisterError(message: "Echec lors de votre inscription");
    }
  }
}
