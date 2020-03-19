import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
            SizedBox(height: 30,),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(widget.content),
                  _image == null
                      ? Text('Aucune image selectionnée')
                      : Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Image.file(_image),
                        ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: getImageFromGallery,
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              child: Text("Prendre une photo", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height:20),
          ],
        ),
      ),
    );
  }
}
