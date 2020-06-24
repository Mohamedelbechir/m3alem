import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/notifdriver_bloc.dart';

enum TypeMenu { driver, passager }
enum NabBarItems { map, historique, statistique, profil }

class CustumBottomNavigation extends StatelessWidget {
  final ValueChanged<int> onSelectNav;
  final int currentIndex;
  final TypeMenu typeMenu;

  CustumBottomNavigation({
    Key key,
    @required this.onSelectNav,
    this.currentIndex = 0,
    @required this.typeMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _items = [];
    final map = BottomNavigationBarItem(
      title: Container(),
      icon: Icon(Icons.explore),
      activeIcon: Icon(Icons.explore, color: Colors.black, size: 30),
    );
    final historique = BottomNavigationBarItem(
      title: Container(),
      icon: Icon(Icons.history),
      activeIcon: Icon(Icons.history, color: Colors.black, size: 30),
    );
    final statistique = BottomNavigationBarItem(
      title: Container(),
      icon: Icon(Icons.trending_up),
      activeIcon: Icon(Icons.trending_up, color: Colors.black, size: 30),
    );
    final profil = BottomNavigationBarItem(
      title: Container(),
      icon: Icon(Icons.person),
      activeIcon: Icon(Icons.person, color: Colors.black, size: 30),
    );
    final notification = BottomNavigationBarItem(
      title: Container(),
      icon: BlocBuilder<NotifDriverBloc, NotifDriverState>(
          builder: (context, state) {
        return Stack(children: [
          Icon(Icons.notifications),
          ((state is NotifLoaded) && state.consulted)
              ? Container(width: 0)
              : (state is NotifDriverInitial)
                  ? Container(width: 0)
                  : Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                      ))
        ]);
      }),
      activeIcon: Icon(Icons.notifications, color: Colors.black, size: 30),
    );

    if (isDriver)
      _items.addAll([map, statistique, historique, notification, profil]);
    else
      _items.addAll([map, historique, profil]);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _items,
      currentIndex: currentIndex,
      onTap: (selectedIndex) => onSelectNav(selectedIndex),
    );
  }

  bool get isDriver => this.typeMenu == TypeMenu.driver;
}
