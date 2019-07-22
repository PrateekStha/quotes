import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import '../admin/update_category.dart';

class categoryDetails extends StatefulWidget {

  final category_detail_id;
  final category_detail_imageName;
  final category_detail_category;
  final category_detail_imageUrl;
  

  categoryDetails({
    this.category_detail_id,
    this.category_detail_imageName,
    this.category_detail_category,
    this.category_detail_imageUrl,

});
  @override
  _categoryDetailsState createState() => _categoryDetailsState();
}

class _categoryDetailsState extends State<categoryDetails> {
  CategoryService _categoryService = CategoryService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Category'),
        ),
      body: new ListView(
        children: <Widget>[
          Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateCategory(
                update_category_id: widget.category_detail_id,
                update_category_category:widget.category_detail_category,
                update_category_imageName:widget.category_detail_imageName
                )));
            },
              color: Colors.green,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Update category",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),
         Container(
              height: 250.0,
              width: double.infinity,
              color: Colors.white,
              child: CachedNetworkImage(
                //placeholder: CircularProgressIndicator(),
                imageUrl: widget.category_detail_imageUrl,
              ),
            ),

          
          Divider(),
         
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Category :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.category_detail_category),),

            ],
          ),

          Divider(),
          
          
         
      Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              //_categoryService.deleteCategory(widget.category_detail_id);
              Navigator.pop(context);
            },
              color: Colors.red,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Delete category",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),

        //similar category part

      ],
      ),
    );
  }
}
