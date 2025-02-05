import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/category.dart';
import '../db/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../admin/admin.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  //services for database
  CategoryService _categoryService = CategoryService();
  PostService _postService = PostService();
  bool loading = false;
  //color assigning to variable
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  //form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController PostNameController = TextEditingController();
  TextEditingController StatusController = TextEditingController();
  TextEditingController AuthorController = TextEditingController();

  //Assigning other variable
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  int likes = 0;
  File _image;

  @override
  void initState() {
    _getCategories();

  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (DocumentSnapshot category in categories) {
      items.add(new DropdownMenuItem(
        child: Text(category['category']),
        value: category['category'],
      ));
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        title: Text(
          "Add Post",
          style: TextStyle(
            
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: loading?LinearProgressIndicator():Column(
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
                  'Upload Post Image',
                  style: TextStyle(color: black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: PostNameController,
                  decoration: InputDecoration(
                    hintText: 'Post name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Enter the Post name';
                    } else if (value.length > 10) {
                      return 'no value more than 10 can enter';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: StatusController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'type status here',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Enter the Status';
                    } else if (value.length > 100) {
                      return 'no value more than 10 can enter';
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    items: getCategoriesDropDown(),
                    value: _currentCategory,
                    hint: Text('Select Category'),
                    onChanged: (value) {
                      setState(() {
                        _currentCategory = value;
                      });
                    },
                  ),
                  
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: AuthorController,
                  decoration: InputDecoration(
                    hintText: 'Author',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Enter the Author';
                    } else if (value.length > 10) {
                      return 'no value more than 10 can enter';
                    }
                  },
                ),
              ),

              RaisedButton(
                child: Text(
                  'Add Post',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  validateAndUpload();
                },
              ),
              Visibility(
                visible: loading ?? true,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.9),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ),
              )
            ],
        ),
          ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
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
      if (_image != null) {
          String imageUrl;
          setState(() {
            loading = true;
          });
          final FirebaseStorage storage = FirebaseStorage.instance;
          final String imageName = "Post" +
              "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task =
              storage.ref().child(imageName).putFile(_image);
          Fluttertoast.showToast(msg: 'Post check');
          StorageTaskSnapshot snapshot1 =
              await task.onComplete.then((snapshot) => snapshot);
          task.onComplete.then((snapshot1) async {
            imageUrl = await snapshot1.ref.getDownloadURL();
            _postService.uploadPost(
                imageUrl,
                PostNameController.text,
                _currentCategory,
                StatusController.text,
                AuthorController.text,
                likes,
                imageName);
            _formKey.currentState.reset();
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Post Added');
          });
      } else {
        Fluttertoast.showToast(msg: 'Please Select the image');
      }
    }
  }
}
