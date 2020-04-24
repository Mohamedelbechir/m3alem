import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  const Tag({Key key, @required this.text, this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 5, bottom: 5),
        decoration: BoxDecoration(
            color: color.withOpacity(.1),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8.0),
        child: Text('$text',
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.bold)));
  }
}
