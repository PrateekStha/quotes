import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../db/category.dart';
import '../db/message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/admin.dart';

class AddMessage extends StatefulWidget {
  @override
  _AddMessageState createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  //services for database
  CategoryService _categoryService = CategoryService();
  MessageService _messageService = MessageService();
  bool loading = false;
  //color assigning to variable
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  //form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController LocationController = TextEditingController();
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
  List<String> likes = <String>[];
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
          "Send your quotes"
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: loading?CircularProgressIndicator():Column(
            children: <Widget>[
              SizedBox(height: 60.0,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Quotes Nepal',
                  style: TextStyle(color: black,fontSize: 20.0,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: AuthorController,
                  decoration: InputDecoration(
                    hintText: 'Author Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Enter the Author Name';
                    } else if (value.length > 20) {
                      return 'no value more than 20 can enter';
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
                    } else if (value.length > 50) {
                      return 'no value more than 50 can enter';
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
                  controller: LocationController,
                  decoration: InputDecoration(
                    hintText: 'Location',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Enter the Author';
                    } else if (value.length > 15) {
                      return 'no value more than 15 can enter';
                    }
                  },
                ),
              ),

              RaisedButton(
                child: Text(
                  'Add Message',
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
                    child: CircularProgressIndicator(
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

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
            _messageService.uploadMessage(   
                AuthorController.text,
                _currentCategory,
                StatusController.text,
                LocationController.text,
                );
            _formKey.currentState.reset();
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Message Sent');
          }
    }
  
}
