import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/blogs.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override

  //fire store gridview
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: const Text('Loading events...'));
        }
        return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Single_product(
                  prod_name: snapshot.data.documents[index]['category'],
                  length: snapshot.data.documents.length),
            );
          },
        );
      },
    );
  }
}

class Single_product extends StatelessWidget {
  final prod_name;
  final length;

  Single_product({this.prod_name, this.length});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: ListTile(
          title: FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VotePage(category: prod_name)));
              },
              icon: Icon(Icons.star,color: Colors.yellow,),
              label: Text("Category",style: TextStyle(color: Colors.white),)),
          subtitle: Text(
            prod_name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          )),
    );
  }
}
