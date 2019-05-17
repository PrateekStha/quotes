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
class UpdatePost extends StatefulWidget {
  final updateId ;
  UpdatePost({this.updateId});
  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  //services for database
  CategoryService _categoryService = CategoryService();
  PostService _postService = PostService();

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
  List<int> selectedSizes = <int>[];
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
        backgroundColor: white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close,color:Colors.red),
        ),
        title: Text(
          "Update Post",
          style: TextStyle(color: black),
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
                decoration: InputDecoration(
                  hintText: 'Status',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must Enter the Status';
                  } else if (value.length > 10) {
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
              child: Text('Add Post'),
              onPressed: () {
                validateAndUpload();
              },
            )
          ],
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
  void validateAndUpload()async{
    if(_formKey.currentState.validate()){
      if(_image != null){
          if(selectedSizes.isNotEmpty){
            String imageUrl;
            
            final FirebaseStorage storage = FirebaseStorage.instance;
            final String imageName = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
            StorageUploadTask task = storage.ref().child(imageName).putFile(_image);
            Fluttertoast.showToast(msg: 'Post check');
            StorageTaskSnapshot snapshot1 = await task.onComplete.then((snapshot)=>snapshot);
            Fluttertoast.showToast(msg: 'Post Added');
            task.onComplete.then((snapshot1) async{
                imageUrl = await snapshot1.ref.getDownloadURL();
                _postService.updatePost(widget.updateId,imageUrl,PostNameController.text,_currentCategory,StatusController.text,AuthorController.text,selectedSizes,imageName);
                _formKey.currentState.reset();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Post Added');
            });
          }else{
            Fluttertoast.showToast(msg: 'select any one sizes');
          }
      }else{
        Fluttertoast.showToast(msg: 'Please Select the image');
      }
    }
  }
}
