import 'package:flutter/material.dart';

buildHeaderModal({BuildContext context, String title}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
            color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 20),
      ),
      FlatButton(
        padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
    ],
  );
}
