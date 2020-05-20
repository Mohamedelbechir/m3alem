import 'custom_button_edit_profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormEmail extends StatefulWidget {
  final Function(String fullName) onSave;
  final String initialValue;
  FormEmail({@required this.onSave, @required this.initialValue});
  @override
  _FormEmailState createState() => _FormEmailState();
}

class _FormEmailState extends State<FormEmail> {
  final _key = GlobalKey<FormState>();
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  String _email;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Saisir votre email',
              style: TextStyle(fontSize: 17),
            ),
            TextFormField(
              initialValue: widget.initialValue,
              onSaved: (value) => _email = value,
              validator: (String value) {
                return !_emailRegExp.hasMatch(value) || value.isEmpty
                    ? 'Adresse email non invalide'
                    : null;
              },
              //decoration: InputDecoration(),
            ),
            // SizedBox(height: 5),
            CustomButtomEditProfil(
              formKey: _key,
              onSave: () => widget.onSave(_email),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
          ],
        ),
      ),
    );
  }
}
