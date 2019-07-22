import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/detailCarousel.dart';
import '../db/Carousel.dart';

class showCarousel extends StatefulWidget {
  @override
  _showCarouselState createState() => _showCarouselState();
}

class _showCarouselState extends State<showCarousel> {
  CarouselService _CarouselService = CarouselService();
  TextEditingController CarouselController = TextEditingController();
  GlobalKey<FormState> _CarouselFormKey = GlobalKey();
  @override
  void initState(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Of Carousels '),
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
                    title: new Text(document['name']),
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
                                  _CarouselService.deleteCarousel(
                                      document['id'], document['imageName']);
                                  Navigator.pop(context);
                                },
                              )
                            ]));
                          });
                    },
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>carouselDetails(carousel_detail_id: document['id'],carousel_detail_imageName: document['imageName'],carousel_detail_name: document['name'],carousel_detail_imageUrl: document['imageUrl'],)));
                    },
                  );
                }).toList(),
              );
            },
          ),
        ));
  }
}
