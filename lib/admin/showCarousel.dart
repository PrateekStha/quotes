import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/carousel.dart';

class showCarousel extends StatefulWidget {
  @override
  _showCarouselState createState() => _showCarouselState();
}

class _showCarouselState extends State<showCarousel> {
  CarouselService _carouselService = CarouselService();
  TextEditingController carouselController = TextEditingController();
  GlobalKey<FormState> _carouselFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Of carousels '),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: new StreamBuilder(
            stream: Firestore.instance.collection('carousels').snapshots(),
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
                    title: new Text("Name : " + document['name']),
                    subtitle: new Text("Carousel Photo"),
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
                                  _carouselService.deleteCarousel(
                                      document['id'], document['imageName']);
                                  Navigator.pop(context);
                                },
                              )
                            ]));
                          });
                    },
                  );
                }).toList(),
              );
            },
          ),
        ));
  }
}
