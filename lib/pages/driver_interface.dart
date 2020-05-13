import 'package:m3alem/bloc/notifdriver_bloc.dart';
import 'package:m3alem/pages/driver_historique_page.dart';
import 'package:m3alem/socket/socket_service_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/pages/driver_map_page.dart';
import 'package:m3alem/pages/driver_money_page.dart';
import 'package:m3alem/pages/driver_setting_page.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/widgets/bottom_navigation_custom.dart';

class DriverInterface extends StatefulWidget {
  @override
  _DriverInterfaceState createState() => _DriverInterfaceState();
}

class _DriverInterfaceState extends State<DriverInterface> {
  int _currentIndex = 0;
  final navigatorKey = GlobalKey<NavigatorState>();

  List<Widget> _listMenu;

  @override
  void initState() {
    final _socket = SocketServiceDriver();
    _listMenu = <Widget>[
      BlocProvider(
        create: (context) => DriverMapBloc(
          authentificationBloc: context.bloc<AuthentificationBloc>(),
          notifDriverBloc: context.bloc<NotifDriverBloc>(),
          utilisateurRepository: context.repository<UtilisateurRepository>(),
          socket: _socket,
        )..add(DisplayDriverMap()),
        child: DriverMapPage(key: AppM3alemKeys.driverMap),
      ),
      DriverMoneyPage(key: AppM3alemKeys.driverMoney),
      DriverHistoriquePage(key: AppM3alemKeys.driverMoney),
      DriverSettingPage(key: AppM3alemKeys.driverSetting),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /* final isFirstRouteInCurrentTab =
               !await _navigatorKeys[_currentNav].currentState.maybePop();
           if (isFirstRouteInCurrentTab) {
             // if not on the 'main' tab
             if (_currentNav != NavItem.map) {
               // select 'main' tab
               _onSelectNav(NavItem.map);
               // back button handled by app
               return false;
             }
           }
           // let system handle back button if we're on the first route
           return isFirstRouteInCurrentTab; */
        return null;
      },
      child: BlocProvider<NotifDriverBloc>(
        create: (context) => NotifDriverBloc(),
        child: Scaffold(
          body: _listMenu[_currentIndex],
          bottomNavigationBar: CustumBottomNavigation(
            typeMenu: TypeMenu.driver,
            currentIndex: _currentIndex,
            onSelectNav: _onSelectNav,
          ),
        ),
      ),
    );
  }

  _onSelectNav(int navIndex) {
    /*   if (_currentIndex == navIndex) {
         // pop to first route
         _navigatorKeys[navIndex].currentState.popUntil((route) => route.isFirst);
       } else { */
    setState(() {
      _currentIndex = navIndex;
    });
    //}
  }
}
