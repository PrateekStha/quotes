import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/message.dart';

class messageDetails extends StatefulWidget {

  final message_detail_id;
  final message_detail_name;
  final message_detail_category;
  final message_detail_location;
  final message_detail_status;

  messageDetails({
    this.message_detail_id,
    this.message_detail_name,
    this.message_detail_category,
    this.message_detail_location,
    this.message_detail_status
});
  @override
  _messageDetailsState createState() => _messageDetailsState();
}

class _messageDetailsState extends State<messageDetails> {
  MessageService _messageService = MessageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('List Of Messages '),
        ),
      body: new ListView(
        children: <Widget>[
         

          
          Divider(),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
              child: new Text("Name :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
              child: new Text(widget.message_detail_name),)
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Category :",style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.message_detail_category),)
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Location :",style: TextStyle(color: Colors.grey)),),
                Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.message_detail_location),)
            ],
          ),
          Divider(),
          ListTile(
              leading: Text('Status',style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.content_copy),
              onTap: (){
                Clipboard.setData(new ClipboardData(text: widget.message_detail_status));
        Fluttertoast.showToast(msg: 'Copied in Clipboard');
              },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
            child: Text(widget.message_detail_status),
          ),
          SizedBox(height: 25.0,),
          
         
      Row(
        children: <Widget>[
          //size button
          Expanded(
            child: MaterialButton(onPressed: (){
              _messageService.deleteMessage(widget.message_detail_id);
              Navigator.pop(context);
            },
              color: Colors.red,
              textColor: Colors.grey,              elevation: 0.2,
              child: new Text("Delete Message",style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
      ),

        //similar message part

      ],
      ),
    );
  }
}
