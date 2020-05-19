import 'package:flutter/material.dart';
import 'package:m3alem/bloc/displayonmap_bloc.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';
import 'package:m3alem/bloc/notifdriver_bloc.dart';
import 'package:m3alem/google_map_services/google_map_service.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/pages/display_on_map.dart';
import 'package:m3alem/utils/utilis_fonctions.dart';

class DriverNotifCard extends StatefulWidget {
  final Course course;

  const DriverNotifCard({Key key, this.course}) : super(key: key);

  @override
  _DriverNotifCardState createState() => _DriverNotifCardState();
}

class _DriverNotifCardState extends State<DriverNotifCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          width: 280,
          height: 400,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          //color: Colors.blueAccent,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(fontSize: 40),
                              text: arrondir(
                                widget.course.prixCourse.toString(),
                              )),
                          TextSpan(
                            text: ' DT  -  ',
                          ),
                          TextSpan(
                              style: TextStyle(fontSize: 40),
                              text:
                                  arrondir(widget.course.distance.toString())),
                          TextSpan(text: ' km'),
                        ]),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Expanded(
                    child: Text('${widget.course.depart}'),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Icon(Icons.assistant_photo),
                  Expanded(
                    child: Text('${widget.course.arrivee}'),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlineButton(
                      child: Text('voir sur map'),
                      onPressed: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return BlocProvider<DisplayOnMapBloc>(
                            create: (context) => DisplayOnMapBloc()
                              ..add(DisplayOnMap(widget.course)),
                            child: DiplayOnMap(),
                          );
                        }));
                      }),
                  RaisedButton(
                      color: Colors.black,
                      child: Text('accepter',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        context
                            .bloc<NotifDriverBloc>()
                            .add(AccepterCourse(widget.course));
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
