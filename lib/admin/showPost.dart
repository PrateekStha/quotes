import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/post.dart';
import '../admin/update_post.dart';

class showPost extends StatefulWidget {
  @override
  _showPostState createState() => _showPostState();
}

class _showPostState extends State<showPost> {
  PostService _postService  = PostService();
  TextEditingController PostController = TextEditingController();
  GlobalKey<FormState> _postFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('List Of Posts '),
       ),
       body:Container(
            padding: const EdgeInsets.all(10.0),
            child: new StreamBuilder(
      stream: Firestore.instance.collection('Posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView  (
          children: snapshot.data.documents.map<Widget>((document) {
            return new ListTile(
              leading: new Image.network(document['imageUrl'],width:80.0,height: 50.0,fit: BoxFit.cover,),
              
              title: new Text("Name : "+document['name']),
              subtitle: new Text("Category : "+ document['category']),
              
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
                         _postService.deletePost(document['id'],document['imageName']);
                          Navigator.pop(context);
                        },
                        )
                    ]
                    )
                );
            });
              },
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePost(updateId:document['id'])));
                          //_updatebrandAlert(document['id'],document['brand']);
                       
                        },

              
            );
          }).toList(),
          
        );
        
      },
    ),
     )
     );
  }



}