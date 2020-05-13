import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/notifdriver_bloc.dart';
import 'package:m3alem/widgets/driver_notif_card.dart';

class DriverNotificationPage extends StatelessWidget {
  DriverNotificationPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.bloc<NotifDriverBloc>().add(ToContultedNotif());
    return Scaffold(
      body: BlocBuilder<NotifDriverBloc, NotifDriverState>(
          builder: (context, state) {
        if (state is NotifLoaded)
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ...state.courses
                  .map((course) => DriverNotifCard(course: course))
                  .toList()
            ],
          );
        return Container(child: Text('Aucune notification à afficher'));
      }),
    );
  }
}
