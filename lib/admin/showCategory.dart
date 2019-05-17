import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';
class showCategory extends StatefulWidget {
  @override
  _showCategoryState createState() => _showCategoryState();
}

class _showCategoryState extends State<showCategory> {
  CategoryService _categoryService  = CategoryService();
  TextEditingController categoryController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('List Of Categories '),
       ),
       body:Container(
            padding: const EdgeInsets.all(10.0),
            child: new StreamBuilder(
      stream: Firestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map<Widget>((document) {
            return new ListTile(
              title: new Text(document['category']),
              onLongPress: () {
        showModalBottomSheet<void>(context: context,
            builder: (BuildContext context) {
                return Container(
                    child: new Wrap(
                    children: <Widget>[
                        new ListTile(
                        leading: new Icon(Icons.delete),
                        title: new Text('Delete'),
                        onTap: (){
                          print('deleted');
                          _categoryService.deleteCategory(document['id']);
                          Navigator.pop(context);
                        },
                        )
                    ]
                    )
                );
            });
              },
              onTap: (){
                          _updatecategoryAlert(document['id'],document['category']);
                        },

              
            );
          }).toList(),
          
        );
        
      },
    ),
     )
     );
  }

  
    void _updatecategoryAlert(docId,String docCategory){
    var alert = new AlertDialog(
      content: Form(
        key:  _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(
            hintText: docCategory
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
             if(categoryController.text != null){
              _categoryService.updateCategory(categoryController.text,docId);
              Fluttertoast.showToast(msg: 'Category Updated');
            Navigator.pop(context);
            }
            
          },
          child: Text('Edit'),
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
         child : Text('Cancel'),
        )
      ],
    );
    showDialog(context: context, builder: (_)=> alert);
  }


}