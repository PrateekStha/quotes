import 'dart:async';
 
import 'dart:async';
 
import 'package:flutter/material.dart';
 
import 'package:cloud_firestore/cloud_firestore.dart';
 
import './crud.dart';
 
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}
 
class _DashboardPageState extends State<DashboardPage> {
  String carModel;
  String carColor;
 
  crudMedthods crudObj = new crudMedthods();
 
  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Data', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car Name'),
                  onChanged: (value) {
                    this.carModel = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter car color'),
                  onChanged: (value) {
                    this.carColor = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.addData({
                    'carName': this.carModel,
                    'color': this.carColor
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }
 
  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addDialog(context);
              },
            )
          ],
        ),
        body: Center());
  }
}