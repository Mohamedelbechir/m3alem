import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/authentification_event.dart';
import 'package:m3alem/models/freezed_classes.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/widgets/custom_profil_numTel.dart';
import 'package:m3alem/widgets/custom_profil_email.dart';
import 'package:m3alem/widgets/custom_profil_fullName.dart';

import 'package:m3alem/bloc/profil_bloc.dart';
import 'package:m3alem/widgets/list_tile_profil.dart';

class PassagerProfilPage extends StatefulWidget {
  const PassagerProfilPage({Key key}) : super(key: key);

  @override
  _PassagerProfilPageState createState() => _PassagerProfilPageState();
}

class _PassagerProfilPageState extends State<PassagerProfilPage> {
  Utilisateur _currentUser;

  final _keyLogin = GlobalKey<FormState>();
  final _keyAdress = GlobalKey<FormState>();
  final _keyPhone = GlobalKey<FormState>();
  final _keyPassWord = GlobalKey<FormState>();

  @override
  void initState() {
    context.bloc<ProfilBloc>().add(DisplayProfil());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthentificationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
      ),
      body: BlocBuilder<ProfilBloc, ProfilState>(
        builder: (context, state) {
          if (state is ProfilDispladed) {
            _currentUser = state.user;
            return Column(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.green[300],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTileProfil(
                        icon: Icon(Icons.account_circle, color: Colors.green),
                        label: 'Nom complet',
                        subTitle:
                            "Ceci correspond à notre nom qui sera visible par les autres utilisateurs de l'application",
                        value: '${_currentUser.nom}',
                        onTap: _onChangeFullName,
                      ),
                      ListTileProfil(
                        icon: Icon(Icons.perm_identity, color: Colors.green),
                        label: 'Card de crédit',
                        subTitle:
                            "Ceci correspond à votre login et ne sera donc pas visible par les autres utilisateurs",
                        value: '${_currentUser.prenom}',
                        onTap: () => _onChangeCreditCard(),
                      ),
                      ListTileProfil(
                        icon: Icon(Icons.email, color: Colors.green),
                        label: 'Adresse email',
                        value: '${_currentUser.email}',
                        onTap: () => _onChangeEmail(),
                      ),
                      ListTileProfil(
                        icon: Icon(Icons.call, color: Colors.green),
                        label: 'Numéro de téléphone',
                        value: '${_currentUser.tel}',
                        onTap: () => _onChangeTel(),
                        separated: false,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.security, color: Colors.green),
                        title: Text('Changer le mot de passe',
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                        onTap: () => _onChangePass(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlineButton(
                      borderSide: BorderSide(color: Colors.green),
                      child: Text('Se déconnecter',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(5),
                              top: Radius.circular(5))),
                      onPressed: () async {
                        Navigator.pop(context);

                        _authenticationBloc.add(LoggedOut());
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  _onChangePass() {
    final ProfilBloc _bloc = BlocProvider.of<ProfilBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: _shap,
      builder: (context) => Container(
        height: MediaQuery.of(context).viewInsets.bottom + 350,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 50),
        child: DraggableScrollableSheet(
          expand: true,
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: .5,
          builder: (context, scrollController) => Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Changer mot de passe',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
                      // color: Colors.grey[100],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onChangeCreditCard() {}
  _onChangeTel() {
    final ProfilBloc _bloc = BlocProvider.of<ProfilBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: _shap,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
        child: FormNumTel(
          initialValue: _currentUser.tel,
          onSave: (value) {
            _bloc.add(UpdatePhoneNumber(number: value));
          },
        ),
      ),
    );
  }

  _onChangeEmail() {
    final ProfilBloc _bloc = BlocProvider.of<ProfilBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: _shap,
      builder: (context) => Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
          child: FormEmail(
            initialValue: _currentUser.email,
            onSave: (value) {
              _bloc.add(UpdateEmail(email: value));
            },
          )),
    );
  }

  _onChangeFullName() {
    final ProfilBloc _bloc = BlocProvider.of<ProfilBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: _shap,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
        child: Container(
            child: FormFullName(
          nom: _currentUser.nom,
          prenom: _currentUser.prenom,
          onSave: (nom, prenom) {
            _bloc.add(UpdateFullName(nom: nom, prenom: prenom));
          },
        )),
      ),
    );
  }

  ShapeBorder get _shap => RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      );
}
