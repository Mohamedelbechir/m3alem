import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/bloc/authentification_state.dart';
import 'package:m3alem/pages/complete_dossier.dart';
import 'package:m3alem/pages/home.dart';
import 'package:m3alem/pages/login_page.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';

import 'widgets/loading_indicator.dart';
import 'package:bloc/bloc.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final utilisateurRepository = UtilisateurRepository();
  runApp(
    BlocProvider<AuthentificationBloc>(
      create: (context) { 
        return AuthentificationBloc(
            utilisateurRepository: utilisateurRepository)
          ..add(AppStarted());
      },
      /* A chaque fois qu'un évement est mis alors 
          il dit aux nœuds dependant de se reconstruire
      */
      child: MyApp(utilisateurRepository: utilisateurRepository),
    ),
  );
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UtilisateurRepository utilisateurRepository;

  MyApp({Key key, @required this.utilisateurRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: true,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      /*  builder: (context, widget) => MultiProvider(
        providers: [
          Provider<RdvRepositorySql>.value(value: RdvRepositorySql()),
          Provider<PatientRepositorySql>.value(value: PatientRepositorySql()),
          Provider<RdvStatusRepositorySql>.value(
              value: RdvStatusRepositorySql()),
          Provider<RdvTypeRepositorySql>.value(value: RdvTypeRepositorySql()),
          Provider<RdvRepository>.value(value: RdvRepository()),
        ],
        child: widget,
      ), */
      builder: (context, widget) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UtilisateurRepository>(
            create: (context) => UtilisateurRepository(),
          ),
          /*  RepositoryProvider<PatientRepositorySql>(
            builder: (context) => PatientRepositorySql(),
          ), */
        ],
        child: widget,
      ),
      home: BlocBuilder<AuthentificationBloc, AuthentificationState>(
        builder: (context, state) {
          if (state is AuthentificationAuthenticated) {
            //return HomePage();
            return HomePage();
          }
          if(state is ImcompletedAccount){
            return ImcompletCompletDossier();
          }
          if (state is AuthentificationUnauthenticated) {
            return LoginPage(
                utilisateurRepository:
                    RepositoryProvider.of<UtilisateurRepository>(context));
          }
          if (state is AuthentificationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      ),
    );
  }
}
