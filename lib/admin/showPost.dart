import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/post.dart';
import '../admin/update_post.dart';
import '../admin/detailPost.dart';

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
      stream: Firestore.instance.collection('Posts').orderBy('created').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView  (
          children: snapshot.data.documents.map<Widget>((document) {
            return new ListTile(
              
              leading: CircleAvatar(child: Text(document['name'][0])),
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
                         _postService.deletePost(document['id']);
                          Navigator.pop(context);
                        },
                        )
                    ]
                    )
                );
            });
              },
               onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>postDetails(post_detail_id: document['id'],post_detail_name: document['name'],post_detail_status: document['status'] ,post_detail_category: document['category'],post_detail_author: document['author'],)));
                    },

              
            );
          }).toList()
          ,
          
        );
        
      },
    ),
     )
     );
  }



}