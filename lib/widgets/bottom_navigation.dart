import 'package:flutter/material.dart';

enum TypeMenu { driver, passager }

class BottomNavigationForDriver extends StatelessWidget {
  final ValueChanged<int> onSelectNav;
  final int currentIndex;
  final TypeMenu typeMenu;

  BottomNavigationForDriver({
    Key key,
    @required this.onSelectNav,
    this.currentIndex = 0,
    @required this.typeMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        title: Container(),
        icon: Icon(Icons.explore),
        activeIcon: Icon(Icons.explore, color: Colors.black, size: 30),
      ),
      BottomNavigationBarItem(
        title: Container(),
        icon: isDriver ? Icon(Icons.trending_up) : Icon(Icons.history),
        activeIcon: Icon(
          isDriver ? Icons.trending_up : Icons.history,
          color: Colors.black,
          size: 30,
        ),
      ),
      BottomNavigationBarItem(
        title: Container(),
        icon: Icon(Icons.person),
        activeIcon: Icon(Icons.person, color: Colors.black, size: 30),
      ),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _items,
      currentIndex: currentIndex,
      onTap: (selectedIndex) => onSelectNav(selectedIndex),
    );
  }

  bool get isDriver => this.typeMenu == TypeMenu.driver;
}
