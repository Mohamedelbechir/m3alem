import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/bloc/passagerhistorique_bloc.dart';
import 'package:m3alem/bloc/profil_bloc.dart';
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/pages/passager_history_page.dart';
import 'package:m3alem/pages/passager_map_page.dart';
import 'package:m3alem/pages/passager_profil_page.dart';
import 'package:m3alem/pages/passager_setting_page.dart';
import 'package:m3alem/repository/course_repository.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/socket/socket_service_passager.dart';
import 'package:m3alem/widgets/bottom_navigation_custom.dart';

class PassagerInterfacePage extends StatefulWidget {
  @override
  _PassagerInterfacePageState createState() => _PassagerInterfacePageState();
}

class _PassagerInterfacePageState extends State<PassagerInterfacePage> {
  int _currentIndex = 0;
  List<Widget> _listMenu;
  @override
  void initState() {
    SocketServicePassager _socket = SocketServicePassager();
    final blocS = SugestionBloc(
      courseRespository: context.repository<CourseRespository>(),
      authentificationBloc: context.bloc<AuthentificationBloc>(),
    );

    final blocMap = PassagerMapBloc(
      utilisateurRepository: context.repository<UtilisateurRepository>(),
      courseRespository: context.repository<CourseRespository>(),
      authentificationBloc: context.bloc<AuthentificationBloc>(),
      sugestionBloc: blocS,
      socket: _socket,
    );

    _listMenu = <Widget>[
      MultiBlocProvider(
        providers: [
          BlocProvider<PassagerMapBloc>.value(
            value: blocMap..add(DisplayPassagerMap()),
          ),
          BlocProvider<SugestionBloc>.value(
            value: blocS,
          ),
        ],
        //  create: (context) => PassagerMapBloc()..add(DisplayPassagerMap()),
        child: PassagerMapPage(key: AppM3alemKeys.passagerMap),
      ),
      BlocProvider<PassagerhistoriqueBloc>(
        create: (_) => PassagerhistoriqueBloc(),
        child: PassagerHistoryPage(key: AppM3alemKeys.passagerHistory),
      ),
      BlocProvider<ProfilBloc>(
        create: (context) => ProfilBloc(
          utilisateurRepository: context.repository<UtilisateurRepository>(),
          authentificationBloc: context.bloc<AuthentificationBloc>(),
        ),
        child: PassagerProfilPage(key: AppM3alemKeys.passagerSetting),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listMenu[_currentIndex],
      bottomNavigationBar: CustumBottomNavigation(
        typeMenu: TypeMenu.passager,
        currentIndex: _currentIndex,
        onSelectNav: _onSelectNav,
      ),
    );
  }

  _onSelectNav(int navIndex) {
    setState(() {
      _currentIndex = navIndex;
    });
  }
}
