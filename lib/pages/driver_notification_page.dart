import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/notifdriver_bloc.dart';
import 'package:m3alem/widgets/driver_notif_card.dart';
import 'package:m3alem/widgets/utilis_buid_widget.dart';

class DriverNotificationPage extends StatefulWidget {
  DriverNotificationPage({Key key}) : super(key: key);

  @override
  _DriverNotificationPageState createState() => _DriverNotificationPageState();
}

class _DriverNotificationPageState extends State<DriverNotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.bloc<NotifDriverBloc>().add(ToConsultedNotif());
    final state = context.bloc<NotifDriverBloc>().state;
  /*  if (state is NotifLoaded) {
      Future.microtask(
        () {
          showModalBottomSheet(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              context: context,
              builder: (context) {
                return Container(
                  height: 400,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                          child: buildHeaderModal(
                              context: context, title: "Notification")),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                            ),
                            state.courses.isEmpty
                                ? Center(child: Text("Aucune notification"))
                                : Container(),
                            ...state.courses
                                .map(
                                    (course) => DriverNotifCard(course: course))
                                .toList(),
                            SizedBox(
                              width: 100,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                );
              });
        },
      );
    }*/
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.remove_red_eye, color: Colors.white),
          onPressed: () {}),
      body: BlocBuilder<NotifDriverBloc, NotifDriverState>(
          builder: (context, state) {
        if (state is NotifLoaded)
          return Column(children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Text("Notifacation"),
              ],
            )),
            Container(
              height: 250,
              child: Align(
                alignment: Alignment(0.2, 0.6),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                    ),
                    ...state.courses
                        .map((course) => DriverNotifCard(course: course))
                        .toList(),
                    SizedBox(
                      width: 100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ]);
        return Container(child: Text('Aucune notification à afficher'));
      }),
    );
    return Scaffold(
      body: BlocBuilder<NotifDriverBloc, NotifDriverState>(
          builder: (context, state) {
        if (state is NotifLoaded)
          return Column(
            children: <Widget>[
              Text("data"),
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ...state.courses
                      .map((course) => DriverNotifCard(course: course))
                      .toList()
                ],
              ),
            ],
          );
        return Container(child: Text('Aucune notification à afficher'));
      }),
    );
  }
}
