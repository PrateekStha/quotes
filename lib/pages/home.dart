import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// self made package
import '../login.dart';
import '../pages/sendMessage.dart';
import '../pages/homeshow.dart';
import '../pages/blogs.dart';
class HomePage extends StatefulWidget {
  HomePage({ this.user, this.googleSignIn});
  final FirebaseUser user ;
  final GoogleSignIn googleSignIn ;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget imagecarousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/pp.jpg'),
          AssetImage('images/pp.jpg'),
          AssetImage('images/pp.jpg'),
          AssetImage('images/pp.jpg'),
          AssetImage('images/pp.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Text('Quote Nepal '),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>AddMessage()));
              }),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //        //header
            new UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.user.photoUrl),
                ),
              ),
              decoration: BoxDecoration(color: Colors.black),
            ),
            //        //body
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('HomePage'),
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favourite'),
                leading: Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                  Fluttertoast.showToast(msg: "Logout Successful");
                });
              },
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.transit_enterexit,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body:
      
      
           //VotePage(),
          Posts()

    );
  }
}


