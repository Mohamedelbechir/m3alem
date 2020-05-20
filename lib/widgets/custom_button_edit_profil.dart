import 'package:flutter/material.dart';

class CustomButtomEditProfil extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final Function onSave;
  CustomButtomEditProfil(
      {Key key, @required this.formKey, @required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          OutlineButton(
              borderSide: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5), top: Radius.circular(5))),
              child: Text(
                'ANNULLER',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () => Navigator.pop(context)),
          SizedBox(width: 5),
          RaisedButton(
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(5), top: Radius.circular(5))),
            child: Text(
              'SAUVEGARDER',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                onSave();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
