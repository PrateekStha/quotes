import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../admin/admin.dart';

class UpdateCategory extends StatefulWidget {
  final update_category_id ;
  final update_category_category ;
  final update_category_imageName ;
  UpdateCategory({this.update_category_id,this.update_category_category,this.update_category_imageName});
  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
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
          "Update Category Image",
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
                    controller: CategoryController,
                    decoration: InputDecoration(
                      hintText: widget.update_category_category,
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
                    'Update Category',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    validateAndUpload(widget.update_category_id,widget.update_category_imageName);
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

  void validateAndUpload(String update_category_id,String update_category_imageName) async {
    if (_formKey.currentState.validate()) {
      String imageUrl;
      final FirebaseStorage storage = FirebaseStorage.instance;
      setState(() {
            loading = true;
          });
          FirebaseStorage.instance.ref().child(update_category_imageName).delete().then((_) => print('Successfully deleted  storage item' ));
      
      String imageName =
          "Category"+"${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task = storage.ref().child(imageName).putFile(_image);
      Fluttertoast.showToast(msg: 'Category check');
      StorageTaskSnapshot snapshot1 =
          await task.onComplete.then((snapshot) => snapshot);
      task.onComplete.then((snapshot1) async {
        imageUrl = await snapshot1.ref.getDownloadURL();
        _categoryService.updateCategory(
            update_category_id,
            imageUrl,
            CategoryController.text,
            imageName,
            );
        _formKey.currentState.reset();
        setState(() {
              loading = false;
            });
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Category Updateed');
      });
    }
  }
}
