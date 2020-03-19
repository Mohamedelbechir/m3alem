
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/login_bloc.dart';
import 'package:m3alem/bloc/login_event.dart';
import 'package:m3alem/bloc/login_state.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';

class LoginPage extends StatelessWidget {
  final UtilisateurRepository utilisateurRepository;

  LoginPage({Key key, @required this.utilisateurRepository})
      : assert(utilisateurRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        builder: (context) {
          return LoginBloc(
            authentificationBloc: BlocProvider.of<AuthentificationBloc>(context),
            utilisateurRepository: utilisateurRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _controllerTextId = TextEditingController();
  TextEditingController _controllerTextPass = TextEditingController();

  //LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    _onLoginButtonPressed() {
      loginBloc.dispatch(LoginButtonPressed(
        username: _controllerTextId.text,
        password: _controllerTextPass.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Center(
                    child: Text(
                  'Authentification',
                  style: TextStyle(
                      color: Colors.green[400],
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 100,
                ),
                Text('Identifiant',
                    style:  TextStyle(color: Colors.black, fontSize: 25), textAlign: TextAlign.left),
                SizedBox(
                  height: 8,
                ),
                TextField(
                    controller: _controllerTextId,
                    decoration: _inputDecoration('Identifiant')),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Mot de passe',
                  style:  TextStyle(color: Colors.black, fontSize: 25),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  obscureText: true,
                  controller: _controllerTextPass,
                  decoration: _inputDecoration('mot de passe'),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      onPressed:
                          state is! LoginLoading ? _onLoginButtonPressed : null,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: state is! LoginLoading
                          ? Text('Se connecter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25))
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _inputDecoration(label) {
    return InputDecoration(
      //labelText: 'Identifiant',
      filled: true,
      fillColor: Colors.grey[200],
      hintText: '$label',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
