import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:m3alem/bloc/authentification_bloc.dart';
import 'package:m3alem/bloc/photos_bloc.dart';
import 'package:m3alem/modelView/model_list_tile_photo.dart';
import 'package:m3alem/repository/utilisateur_repository.dart';
import 'package:m3alem/utils/code_image.dart';
import 'package:m3alem/widgets/item_add_photo_document.dart';

class ImcompletCompletDossier extends StatefulWidget {
  @override
  _ImcompletCompletDossierState createState() =>
      _ImcompletCompletDossierState();
}

class _ImcompletCompletDossierState extends State<ImcompletCompletDossier> {
  final _items = <ModelItemListTilePhoto>[
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoPermis,
        title: "Permis de conduire",
        itemAddPhotoDocTitle:
            "Veillez prendre la photo de votre permis de conduire",
        itemAddPhotoDocContent: "infos"),
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoAssurance,
        title: "Attestation d'assurance",
        itemAddPhotoDocTitle:
            "Veillez prendre la photo de votre permis de conduire",
        itemAddPhotoDocContent: "infos"),
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoCarteGrise,
        title: "Carte grise",
        itemAddPhotoDocTitle:
            "Veillez prendre la photo de votre permis de conduire",
        itemAddPhotoDocContent: "infos"),
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoVoiture,
        title: "Photo exterieur",
        itemAddPhotoDocTitle:
            "Veillez prendre la photo de votre permis de conduire",
        itemAddPhotoDocContent: "infos"),
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoPieceIdentite,
        title:
            "Pièce d'identité en cour de validité (carte d'identité, passport)",
        itemAddPhotoDocTitle:
            "Veillez prendre la photo de votre pièce d'identité",
        itemAddPhotoDocContent: "infos"),
    ModelItemListTilePhoto(
        codePhoto: CodePhoto.photoIdentite,
        title: "Votre photo (de face, l'uminosité suffisance)",
        itemAddPhotoDocTitle:
            "Veillez prendre une photo de vous",
        itemAddPhotoDocContent: "infos"),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthentificationBloc>().currentUser;

    return Scaffold(
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
                child: ListView.separated(
                  separatorBuilder: (_, index) => Divider(color: Colors.grey),
                  itemCount: _items.length,
                  itemBuilder: (context, index) => BlocProvider<PhotosBloc>(
                    create: (context) => PhotosBloc(
                      authentificationBloc:
                          context.bloc<AuthentificationBloc>(),
                      utilisateurRepository:
                          context.repository<UtilisateurRepository>(),
                    )..add(TestHasPhoto(codePhoto: _items[index].codePhoto)),
                    child: ListTilePhoto(modelItemListTilePhoto: _items[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListTilePhoto extends StatefulWidget {
  final ModelItemListTilePhoto modelItemListTilePhoto;
  /* final String codePhoto;
  final String title;
  final String itemAddPhotoDocTitle;
  final String itemAddPhotoDocContent;
 */
  const ListTilePhoto({
    Key key,
    this.modelItemListTilePhoto,
  }) : super(key: key);
  @override
  _ListTilePhotoState createState() => _ListTilePhotoState();
}

class _ListTilePhotoState extends State<ListTilePhoto> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosBloc, PhotosState>(
      builder: (context, state) {
        return Ink(
          color: Colors.grey[200],
          child: ListTile(
            trailing: Icon(Icons.arrow_right),
            leading: (state is PhotoHasNotUploaded)
                ? Icon(Icons.do_not_disturb, color: Colors.red)
                : Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text('${widget.modelItemListTilePhoto.title}'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider<PhotosBloc>(
                      create: (context) => PhotosBloc(
                        authentificationBloc:
                            context.bloc<AuthentificationBloc>(),
                        utilisateurRepository:
                            context.repository<UtilisateurRepository>(),
                      ),
                      child: ItemAddPhotoDoc(
                        codePhoto: widget.modelItemListTilePhoto.codePhoto,
                        title:
                            widget.modelItemListTilePhoto.itemAddPhotoDocTitle,
                        content:
                            widget.modelItemListTilePhoto.itemAddPhotoDocContent,
                      ),
                    );
                  },
                ),
              );
              context.bloc<PhotosBloc>().add(TestHasPhoto(
                  codePhoto: widget.modelItemListTilePhoto.codePhoto));
            },
          ),
        );
      },
    );
  }
}
