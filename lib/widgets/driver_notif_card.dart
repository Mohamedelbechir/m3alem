import 'package:flutter/material.dart';
import 'package:m3alem/bloc/driver_map_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/utils/utilis_fonctions.dart';

class DriverNotifCard extends StatelessWidget {
  final Course course;

  const DriverNotifCard({Key key, this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              width: 280,
              height: 500,
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
                                    course.prixCourse.toString(),
                                  )),
                              TextSpan(
                                text: ' DT  -  ',
                              ),
                              TextSpan(
                                  style: TextStyle(fontSize: 40),
                                  text: arrondir(course.distance.toString())),
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
                        child: Text('${course.depart}'),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.assistant_photo),
                      Expanded(
                        child: Text('${course.arrivee}'),
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
                          child: Text('voir sur map'), onPressed: () {}),
                      RaisedButton(
                          color: Colors.black,
                          child: Text('accepter',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            context
                                .bloc<DriverMapBloc>()
                                .add(AccepterCourse(course));
                          })
                    ],
                  )
                ],
              ),
            ),
          )
        ;
  }
}