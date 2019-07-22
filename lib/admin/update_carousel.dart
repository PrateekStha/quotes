import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/carousel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../admin/admin.dart';

class UpdateCarousel extends StatefulWidget {
  final update_carousel_id ;
  final update_carousel_name ;
  final update_carousel_imageName ;
  UpdateCarousel({this.update_carousel_id,this.update_carousel_name,this.update_carousel_imageName});
  @override
  _UpdateCarouselState createState() => _UpdateCarouselState();
}

class _UpdateCarouselState extends State<UpdateCarousel> {
  //services for database
  CarouselService _carouselService = CarouselService();
  //color assigning to variable
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  //form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController CarouselController = TextEditingController();
  bool loading = false;
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
          "Update Carousel Image",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child:  SingleChildScrollView(
          child:loading?LinearProgressIndicator():Column(
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
                    "Upload Image",
                    style: TextStyle(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: CarouselController,
                    decoration: InputDecoration(
                      hintText: widget.update_carousel_name,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Enter the Carousel name';
                      }
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    'Update Carousel',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    validateAndUpload(widget.update_carousel_id,widget.update_carousel_imageName);
                  },
                )
              ],
            ),
          
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
        child: Icon(Icons.add_a_photo, color: grey),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(40.0),
        child: Image.file(_image),
      );
    }
  }

  void validateAndUpload(String update_carousel_id,String update_carousel_imageName) async {
    if (_formKey.currentState.validate()) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      
      String imageUrl;
      setState(() {
            loading = true;
          });
      
      FirebaseStorage.instance.ref().child(update_carousel_imageName).delete().then((_) => print('Successfully deleted  storage item' ));
      String imageName =
          "Carousel"+"${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task = storage.ref().child(imageName).putFile(_image);
      Fluttertoast.showToast(msg: 'Carousel check');
      StorageTaskSnapshot snapshot1 =
          await task.onComplete.then((snapshot) => snapshot);
      task.onComplete.then((snapshot1) async {
        imageUrl = await snapshot1.ref.getDownloadURL();
        _carouselService.updateCarousel(
            update_carousel_id,
            imageUrl,
            CarouselController.text,
            imageName,
            );
        _formKey.currentState.reset();
        setState(() {
              loading = false;
            });
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Carousel Updateed');
      });
    }
  }
}
