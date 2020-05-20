import 'package:flutter/material.dart';

class ListTileProfil extends StatelessWidget {
  final String label;
  final String value;
  final String subTitle;
  final Function onTap;
  final bool separated;
  final Widget icon;
  ListTileProfil(
      {Key key,
      @required this.label,
      @required this.value,
      this.icon,
      this.subTitle,
      this.separated = true,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$label',
              style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$value',
                style: TextStyle(color: Colors.black),
              ),
              Icon(Icons.edit, color: Colors.grey)
            ],
          ),
          SizedBox(height: 15),
          subTitle != null
              ? Text(
                  "$subTitle",
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  textAlign: TextAlign.justify,
                )
              : Container(),
          SizedBox(height: 1),
          separated ? Divider() : Container(),
        ],
      ),
      onTap: onTap,
    );
  }
}
