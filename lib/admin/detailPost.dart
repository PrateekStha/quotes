import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/update_category.dart';
import '../admin/update_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/post.dart';

class postDetails extends StatefulWidget {

  final post_detail_id;
  final post_detail_name;
  final post_detail_category;
  final post_detail_author;
  final post_detail_status;

  postDetails({
    this.post_detail_id,
    this.post_detail_name,
    this.post_detail_category,
    this.post_detail_author,
    this.post_detail_status
});
  @override
  _postDetailsState createState() => _postDetailsState();
}

class _postDetailsState extends State<postDetails> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('List Of posts '),
        ),
      body: new ListView(
        children: <Widget>[
          Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePost(
                updateId: widget.post_detail_id,
                updateName:widget.post_detail_name,
                updateAuthor : widget.post_detail_author,
                )));
            },
              color: Colors.green,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Update post",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),

          
          Divider(),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
              child: new Text("Name :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
              child: new Text(widget.post_detail_name),)
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Category :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.post_detail_category),)
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("author :",style: TextStyle(color: Colors.grey)),),
                Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.post_detail_author),)
            ],
          ),
          Divider(),
          ListTile(
              leading: Text('Status',style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.content_copy),
              onTap: (){
                Clipboard.setData(new ClipboardData(text: widget.post_detail_status));
        Fluttertoast.showToast(msg: 'Copied in Clipboard');
              },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
            child: Text(widget.post_detail_status),
          ),
          SizedBox(height: 25.0,),
          
         
      Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              _postService.deletePost(widget.post_detail_id);
              Navigator.pop(context);
            },
              color: Colors.red,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Delete post",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),

        //similar post part

      ],
      ),
    );
  }
}
