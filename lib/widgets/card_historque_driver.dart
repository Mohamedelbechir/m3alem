import 'package:flutter/material.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:timeago/timeago.dart' as timeago;

class CardHistoriqueDriver extends StatefulWidget {
  final CourseHistorique courseHist;

  const CardHistoriqueDriver({Key key, @required this.courseHist})
      : super(key: key);
  @override
  _CardHistoriqueDriverState createState() => _CardHistoriqueDriverState();
}

class _CardHistoriqueDriverState extends State<CardHistoriqueDriver> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                        text: "${widget.courseHist.prixCourse}",
                      ),
                      TextSpan(
                        style: TextStyle(fontSize: 15),
                        text: "DT",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    " |  ${getTimeAgo(widget.courseHist.dateCourse)}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.pin_drop),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.courseHist.depart),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.assistant_photo),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.courseHist.arrivee),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(DateTime date) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    return timeago.format(date, locale: 'fr');
  }
}
