import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m3alem/bloc/photos_bloc.dart';
import 'package:m3alem/block/authentification_block.dart';
import 'package:m3alem/widgets/item_add_photo_document.dart';

class ImcompletCompletDossier extends StatefulWidget {
  @override
  _ImcompletCompletDossierState createState() =>
      _ImcompletCompletDossierState();
}

class _ImcompletCompletDossierState extends State<ImcompletCompletDossier> {
  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthentificationBloc>(context).currentUser;

    return BlocProvider<PhotosBloc>(
      builder: (context) => PhotosBloc(),
          child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              "Bienvenue ${user.prenom},",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Étapes obligatoires \nVoici ce que vous devez faire pour configurer votre compte.",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.arrow_right),
                        leading:
                            Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text("Permis de conduire"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ItemAddPhotoDoc(
                            title:
                                '''Prenez une photo de votre Attestation d'assurance avec plaque du véhicule et mention "transport de personnes à titre onéreux" visible (RC circulation)''',
                            content:
                                ''' L'attestation d'assurance auto ou la responsabilité civile circulation est un document qui certifie que votre véhicule est assuré pour une activité de VTC en plus d'un usage à titre personnel. Conseils pour que le document soit accepté : 1) Assurez-vous que le document est lisible et que l'intégralité des informations figure dans le champ de la photo. 2) Ne confondez pas cette assurance avec la responsabilité civile professionnelle (exploitation). La responsabilité civile professionnelle est également requise, mais elle couvre votre entreprise et non votre véhicule. 3) Ce document doit indiquer que votre véhicule est assuré pour le transport de personnes à titre onéreux (ou activité de taxi) et doit également préciser l'immatriculation de votre véhicule. ATTENTION : ce document est différent de la carte verte du véhicule. Cette attestation d'assurance et la carte verte doivent avoir été émises par la même compagnie d'assurance. Par ailleurs, lorsque vous mettez ce document en ligne, assurez-vous que la carte grise et la carte verte de votre véhicule sont déjà enregistrées sur votre compte partenaire.''',
                          );
                        })),
                        trailing: Icon(Icons.arrow_right),
                        leading: Icon(Icons.do_not_disturb, color: Colors.red),
                        title: Text("Attestation d'assurance"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.arrow_right),
                        leading: Icon(Icons.do_not_disturb, color: Colors.red),
                        title: Text("Carte grise"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.arrow_right),
                        title:
                            Text("Photo extérieur (face avant, plaque visible)"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.arrow_right),
                        leading:
                            Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text(
                            "Pièce d'identité en cour de validé (carte d'intentié, passport)"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    Ink(
                      color: Colors.grey[200],
                      child: ListTile(
                        onTap: () {},
                        trailing: Icon(Icons.arrow_right),
                        leading:
                            Icon(Icons.check_circle_outline, color: Colors.green),
                        title:
                            Text("Votre photo (de face, luminosité suffisante)"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
