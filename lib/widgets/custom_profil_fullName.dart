import 'package:flutter/material.dart';
import 'custom_button_edit_profil.dart';
import 'package:flutter/widgets.dart';

class FormFullName extends StatefulWidget {
  final Function(String nom,String prenom) onSave;
  final String nom;
  final String prenom;
  FormFullName({Key key, this.onSave, @required this.nom, @required this.prenom})
      : super(key: key);

  @override
  _FormFullNameState createState() => _FormFullNameState();
}

class _FormFullNameState extends State<FormFullName> {
  final _keyFormFullName = GlobalKey<FormState>();
  String nom;
  String prenom;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyFormFullName,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Nom',
            style: TextStyle(fontSize: 17),
          ),
          TextFormField(
            initialValue: widget.nom,
            onSaved: (value) => nom = value,
            validator: (String value) {
              return value.contains('@') || value.isEmpty
                  ? 'Nom invalide'
                  : null;
            },
          ),
          Text(
            'Prenom',
            style: TextStyle(fontSize: 17),
          ),
          TextFormField(
            initialValue: widget.prenom,
            onSaved: (value) => prenom = value,
            validator: (String value) {
              return value.contains('@') || value.isEmpty
                  ? 'invalide'
                  : null;
            },
          ),
          CustomButtomEditProfil(
            formKey: _keyFormFullName,
            onSave: () => widget.onSave(nom,prenom),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
        ],
      ),
    );
  }
}
