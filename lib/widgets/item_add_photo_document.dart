import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3alem/bloc/photos_bloc.dart';
import 'package:m3alem/utils/code_image.dart';

class ItemAddPhotoDoc extends StatefulWidget {
  final String title;
  final String content;
  ItemAddPhotoDoc({@required this.title, @required this.content});
  @override
  _ItemAddPhotoDocState createState() => _ItemAddPhotoDocState();
}

class _ItemAddPhotoDocState extends State<ItemAddPhotoDoc> {
  File _image;
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => _image = image);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(widget.content),
                  BlocBuilder<PhotosBloc, PhotosState>(
                    builder: (context, state) {
                      if (state is PhotosInitial) if (_image == null)
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text('Aucune image selectionnée'),
                          ),
                        );
                      else {
                        return Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Image.file(_image));
                      }
                      else if (state is PhotoLoaded)
                        return Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Image.file(state.file),
                        );
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: _image == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  onPressed: getImageFromGallery,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    "Prendre une photo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                _image != null
                    ? Container(
                        margin: EdgeInsets.only(left: 20),
                        child: RaisedButton(
                          onPressed: () => context.bloc<PhotosBloc>().add(
                                AddPhoto(
                                  codePhoto: CodePhoto.photoAssurance,
                                  file: _image,
                                ),
                              ),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            "Terminer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
