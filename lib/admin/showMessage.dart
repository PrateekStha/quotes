import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/detailMessage.dart';
import '../db/message.dart';

class showMessage extends StatefulWidget {
  @override
  _showMessageState createState() => _showMessageState();
}

class _showMessageState extends State<showMessage> {
  MessageService _messageService = MessageService();
  TextEditingController MessageController = TextEditingController();
  GlobalKey<FormState> _messageFormKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Of Messages '),
        ),
        body: Container(
          padding: const EdgeInsets.all(4.0),
          child: new StreamBuilder(
            stream: Firestore.instance.collection('Messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              return new ListView(
                children: snapshot.data.documents.map<Widget>((document) {
                  return new ListTile(
                    leading: CircleAvatar(child: Text(document['name'][0])),
                    title: new Text("Name : " + document['name']),
                    subtitle: new Text("Category : " + document['category']),
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
                                  _messageService.deleteMessage(document['id']);
                                  Navigator.pop(context);
                                },
                              )
                            ]));
                          });
                    },
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>messageDetails(message_detail_id: document['id'],message_detail_name: document['name'],message_detail_status: document['status'] ,message_detail_category: document['category'],message_detail_location: document['location'],)));
                    },
                  );
                }).toList(),
              );
            },
          ),
        ));
  }
}
