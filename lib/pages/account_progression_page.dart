import 'package:flutter/material.dart';

class AccountProgressionPage extends StatelessWidget {
  final String etat;
  final String message;
  AccountProgressionPage({@required this.etat, @required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Info(message: message,),
            SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String message;
  const Info({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(width: 1, color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$message",
              softWrap: true,
              maxLines: 2,
              style: TextStyle(color: Colors.blue, fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
