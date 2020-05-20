import 'package:flutter/material.dart';
import 'custom_button_edit_profil.dart';

class FormNumTel extends StatefulWidget {
  final Function(String tel) onSave;
  final String initialValue;
  FormNumTel({@required this.onSave, this.initialValue = ''});
  @override
  _FormNumTelState createState() => _FormNumTelState();
}

class _FormNumTelState extends State<FormNumTel> {
  final RegExp _telRegExp = RegExp(
    r'^[0-9]{8}',
  );
  final _key = GlobalKey<FormState>();
  String _number;
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
              'Saisir votre numéro de téléphone',
              style: TextStyle(fontSize: 17),
            ),
            TextFormField(
              initialValue: widget.initialValue,
              onSaved: (value) => _number = value,
              validator: (String value) {
                return value.length != 8 || value.isEmpty
                    ? 'Numéro de télephone non invalide'
                    : null;
              },
              //decoration: InputDecoration(),
            ),
            // SizedBox(height: 5),
            CustomButtomEditProfil(
              formKey: _key,
              onSave: () => widget.onSave(_number),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
          ],
        ),
      ),
    );
  }
}
