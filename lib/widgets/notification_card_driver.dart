import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/passager_map_bloc.dart';
import 'package:m3alem/bloc/sugestion_bloc.dart';
import 'package:m3alem/models/freezed_classes.dart';

class CardNotificationDriver extends StatefulWidget {
  final ModelCardNotification model;

  const CardNotificationDriver({Key key, @required this.model})
      : super(key: key);
  @override
  _CardNotificationDriverState createState() => _CardNotificationDriverState();
}

class _CardNotificationDriverState extends State<CardNotificationDriver> {
  _buidCircularAvatar(String name) {
    double avatarWidth = 45;
    final _color = Colors.black38;
    return Container(
      width: avatarWidth,
      height: avatarWidth,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: _color),
          color: _color.withOpacity(.1),
          borderRadius: BorderRadius.circular(avatarWidth / 2)),
      child: Center(
        child: Text(
          '${name.substring(0, 1).toUpperCase()}',
          style: TextStyle(
              color: _color, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _buidCircularAvatar(widget.model.nom),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.model.nom,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('${widget.model.rating}'),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.drive_eta),
                    Text(
                      widget.model.typeVoiture,
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.grey[200]),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5),
                    child: Icon(
                      Icons.watch_later,
                      size: 15,
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '30 mn',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlineButton(
                    color: Colors.black,
                    child: Text(
                      'avis',
                    ),
                    onPressed: () {}),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.black,
                      child: Text(
                        'Valider',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        final course = context
                            .bloc<SugestionBloc>()
                            .currentCourse
                            .copyWith(idDriver: widget.model.cin);
                        context
                            .bloc<PassagerMapBloc>()
                            .add(SendResquestToDriver(course));
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
