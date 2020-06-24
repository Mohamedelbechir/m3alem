import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/driverhistorique_bloc.dart';
import 'package:m3alem/widgets/card_historque_driver.dart';

class DriverHistoriquePage extends StatefulWidget {
  DriverHistoriquePage({Key key}) : super(key: key);
  @override
  _DriverHistoriquePageState createState() => _DriverHistoriquePageState();
}

class _DriverHistoriquePageState extends State<DriverHistoriquePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriverhistoriqueBloc, DriverhistoriqueState>(
          builder: (context, state) {
        if (state is DriverhistoriqueLoaded)
          return Column(children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 8),
                Text(
                  "Historique des courses",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                    ),
                    ...state.courses
                        .map((item) => CardHistoriqueDriver(courseHist: item))
                        .toList(),
                    SizedBox(
                      width: 100,
                    ),
                  ],
                ),
              ),
            ),
          ]);
        return Container();
      }),
    );
  }
}
