import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/detailCategory.dart';
import '../db/category.dart';

class showCategory extends StatefulWidget {
  @override
  _showCategoryState createState() => _showCategoryState();
}

class _showCategoryState extends State<showCategory> {
  CategoryService _categoryService = CategoryService();
  TextEditingController CategoryController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  @override
  void initState(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Of categories '),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: new StreamBuilder(
            stream: Firestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              return new ListView(
                children: snapshot.data.documents.map<Widget>((document) {
                  return new ListTile(
                    leading: new Image.network(
                      document['imageUrl'],
                      width: 80.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: new Text(document['category']),
                    onLongPress: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                child: new Wrap(children: <Widget>[
                              new ListTile(
                                leading: new Icon(Icons.delete),
                                title: new Text('Delete'),
                                onTap: () {
                                  print('deleted');
                                  _categoryService.deleteCategory(
                                      document['id'], document['imageName']);
                                  Navigator.pop(context);
                                },
                              )
                            ]));
                          });
                    },
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>categoryDetails(category_detail_id: document['id'],category_detail_imageName: document['imageName'],category_detail_category: document['category'],category_detail_imageUrl: document['imageUrl'],)));
                    },
                  );
                }).toList(),
              );
            },
          ),
        ));
  }
}
