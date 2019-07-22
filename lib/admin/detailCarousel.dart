import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:quotes/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/carousel.dart';
import '../admin/update_carousel.dart';

class carouselDetails extends StatefulWidget {

  final carousel_detail_id;
  final carousel_detail_imageName;
  final carousel_detail_name;
  final carousel_detail_imageUrl;
  

  carouselDetails({
    this.carousel_detail_id,
    this.carousel_detail_imageName,
    this.carousel_detail_name,
    this.carousel_detail_imageUrl,

});
  @override
  _carouselDetailsState createState() => _carouselDetailsState();
}

class _carouselDetailsState extends State<carouselDetails> {
  CarouselService _CarouselService = CarouselService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('carousel'),
        ),
      body: new ListView(
        children: <Widget>[
          Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateCarousel(
                update_carousel_id: widget.carousel_detail_id,
                update_carousel_name:widget.carousel_detail_name,
                update_carousel_imageName:widget.carousel_detail_imageName
                )));
            },
              color: Colors.green,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Update carousel",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),
         Container(
              height: 250.0,
              width: double.infinity,
              color: Colors.white,
              child: CachedNetworkImage(
                //placeholder: CircularProgressIndicator(),
                imageUrl: widget.carousel_detail_imageUrl,
              ),
            ),

          
          Divider(),
         
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("carousel :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.carousel_detail_name),),

            ],
          ),

          Divider(),
          
          
         
      Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              //_CarouselService.deletecarousel(widget.carousel_detail_id);
              Navigator.pop(context);
            },
              color: Colors.red,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Delete carousel",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),

        //similar carousel part

      ],
      ),
    );
  }
}
