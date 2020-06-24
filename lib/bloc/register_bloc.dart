import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/type_utilisateur.dart';

part 'register_event.dart';
part 'register_state.dart';

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
    if (event is AddResgister) {
      yield* _mapAddUserToState(event);
    }
  }

  Stream<RegisterState> _mapAddUserToState(AddResgister event) async* {
    try {
      //Verifier si l'utilisateut existe
      final resultUser =
          await utilisateurRepository.getByCin(event.utilisateur.cin);
      if (resultUser == null) {
        final user = await this.utilisateurRepository.add(event.utilisateur);
        if (user != null) {
          yield RegisterSuccess(utilisateur: user);
          if (user.typeUtilisateur == TypeUtilisateur.chauffeur)
            authentificationBloc.add(AccountIncomplet(utilisateur: user));
          else if (user.typeUtilisateur == TypeUtilisateur.passager) {
            authentificationBloc.add(AccountCompleted(utilisateur: user));
          }
        } else
          yield RegisterError(message: "Echec lors de votre inscription");
      } else {
        // Utilisateur existe déjà
        yield RegisterError(message: "Cet utilisateur existe déjà");
      }
    } catch (_) {
      yield RegisterError(message: "Echec lors de votre inscription");
    }
  }
}
