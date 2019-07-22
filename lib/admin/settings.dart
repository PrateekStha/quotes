import 'package:flutter/material.dart';
import '../admin/changePassword.dart';

class showList extends StatefulWidget {
  @override
  _showListState createState() => _showListState();
}

class _showListState extends State<showList> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Settings'),
       ),
       body:Container(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
  children: <Widget>[
    Card(
      child: ListTile(
        leading: Icon(Icons.vpn_key),
        title: Text('Change Password'),
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>changePassword()));
        },
      ),
    ),
  ]
            )
     )
     );
  }



}