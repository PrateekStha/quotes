import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/carousel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../admin/admin.dart';

class AddCarousel extends StatefulWidget {
  @override
  _AddCarouselState createState() => _AddCarouselState();
}

class _AddCarouselState extends State<AddCarousel> {
  //services for database
  CarouselService _carouselService = CarouselService();
  //color assigning to variable
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  //form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController CarouselController = TextEditingController();

  File _image;

  @override





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close, color: Colors.red),
        ),
        title: Text(
          "Add Carousel Image",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: grey.withOpacity(0.8), width: 1.0),
                    onPressed: () {
                      _selectImage(
                          ImagePicker.pickImage(source: ImageSource.gallery));
                    },
                    child: _displayImage(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Upload Carousel Image',
                style: TextStyle(color: black),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: CarouselController,
                decoration: InputDecoration(
                  hintText: 'Carousel name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must Enter the Carousel name';
                  } else if (value.length > 10) {
                    return 'no value more than 10 can enter';
                  }
                },
              ),
            ),
            RaisedButton(
              child: Text(
                'Add Carousel',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () {
                validateAndUpload();
              },
            )
          ],
        ),
      ),
    );
  }

  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    _image = tempImg;
  }

  Widget _displayImage() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Icon(Icons.add, color: grey),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.file(_image),
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      String imageUrl;
      final FirebaseStorage storage = FirebaseStorage.instance;
      String imageName =
          "Carousel"+"${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task = storage.ref().child(imageName).putFile(_image);
      Fluttertoast.showToast(msg: 'Carousel check');
      StorageTaskSnapshot snapshot1 =
          await task.onComplete.then((snapshot) => snapshot);
      task.onComplete.then((snapshot1) async {
        imageUrl = await snapshot1.ref.getDownloadURL();
        _carouselService.uploadCarousel(
            imageUrl,
            CarouselController.text,
            imageName,
            );
        _formKey.currentState.reset();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Carousel Added');
      });
    }
  }
}
