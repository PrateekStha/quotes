import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../admin/admin.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  //services for database
  CategoryService _categoryService = CategoryService();
  //color assigning to variable
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  //form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController CategoryController = TextEditingController();
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
          "Add Category Image",
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
                              ImagePicker.pickImage(source: ImageSource.gallery ,  maxHeight:  200 , maxWidth: 200 ));
                        },
                        child: _displayImage(),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Upload Category Image',
                    style: TextStyle(color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: CategoryController,
                    decoration: InputDecoration(
                      hintText: 'Category name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must Enter the Category name';
                      } 
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    'Add Category',
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
      setState(() {
            loading = true;
          });
      final FirebaseStorage storage = FirebaseStorage.instance;
      String imageName =
          "Category"+"${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task = storage.ref().child(imageName).putFile(_image);

      Fluttertoast.showToast(msg: 'Uploading.....');

      StorageTaskSnapshot snapshot1 =
          await task.onComplete.then((snapshot) => snapshot);
      task.onComplete.then((snapshot1) async {
        imageUrl = await snapshot1.ref.getDownloadURL();
        
        _categoryService.uploadCategory(
            imageUrl,
            CategoryController.text,
            imageName,
            );
        _formKey.currentState.reset();
        setState(() {
              loading = false;
            });
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Category Added');
      });
    }
  }
}
