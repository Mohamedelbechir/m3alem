import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/m3alem_keys.dart';
import 'package:m3alem/pages/passager_history_page.dart';
import 'package:m3alem/pages/passager_map_page.dart';
import 'package:m3alem/pages/passager_setting_page.dart';
import 'package:m3alem/widgets/bottom_navigation_custom.dart';

class PassagerInterfacePage extends StatefulWidget {
  @override
  _PassagerInterfacePageState createState() => _PassagerInterfacePageState();
}

class _PassagerInterfacePageState extends State<PassagerInterfacePage> {
  int _currentIndex = 0;
  final _listMenu = <Widget>[
    BlocProvider(
      create: (context) => PassagerMapBloc()..add(DisplayPassagerMap()),
      child: PassagerMapPage(key: AppM3alemKeys.passagerMap),
    ),
    PassagerHistoryPage(key: AppM3alemKeys.passagerHistory),
    PassagerSettingPage(key: AppM3alemKeys.passagerSetting),
  ];

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
