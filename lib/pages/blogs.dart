import 'dart:io';
//import 'dart:_http';
import 'dart:typed_data';
import 'package:http/io_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:esys_flutter_share/esys_flutter_share.dart';

class VotePage extends StatefulWidget {
  VotePage({this.category});
  final category;
  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  // We use SharedPreferences to keep track of which names are voted.
  SharedPreferences _preferences;
  static const kVotedPreferenceKeyPrefx = 'AlreadyLikedFor_';
  static const kFavouritePreferenceKeyPrefx = 'AlreadyFavouriteFor_'
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._preferences = prefs);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category,),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          // In firestore console I added a "name_voting" collection.
          stream: Firestore.instance.collection('Posts').where('category', isEqualTo: widget.category).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              final List<_LikeRecord> records = snapshot.data.documents
                  .map((snapshot) => _LikeRecord.fromSnapshot(snapshot))
                  .toList()
                    ..sort((record1, record2) => record2.created - record1.created);
              return ListView(
                children: records
                    .map((record) => _buildListItem(context, record))
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }

  // Returns whether you already voted for post.
  bool _isVoted(String post) {
    return this._preferences.getBool('$kVotedPreferenceKeyPrefx$post') ?? false;
  }

  // Mark a name as voted or not-voted.
  Future<Null> _markVotedStatus(String post, bool voted) async {
    this._preferences.setBool('$kVotedPreferenceKeyPrefx$post', voted);
  }

  // Build a list item corresponding to a _nameVotingRecord.
  Widget _buildListItem(BuildContext context, _LikeRecord record) {
    final key = new GlobalKey<ScaffoldState>();
    String firstHalf;
    String secondHalf;
    bool textflag = true;

    if (record.status.length > 50) {
      firstHalf = record.status.substring(0, 50);
      secondHalf = record.status.substring(50, record.status.length);
    } else {
      firstHalf = record.status;
      secondHalf = "";
    }

    return new Card(
      // title: document['title'],
      // description: document['description'],
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250.0,
              width: double.infinity,
              color: Colors.white,
              child: CachedNetworkImage(
            //placeholder: CircularProgressIndicator(),
            imageUrl:
                record.imageUrl,
          ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: this._isVoted(record.name)
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border, color: Colors.black),
                    onPressed: () => this._toggleVoted(record),
                  ),
                ),
                
                Expanded(
                  child: Text(
                    record.likes.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 60.0,),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    _onImageShareButtonPressed(record.imageUrl);
                  },
                )),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.content_copy,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: record.status));
                    Fluttertoast.showToast(msg: 'Copied in Clipboard');
                  },
                )),
              ],
            ),
            // ListTile(
            //   leading: Text(
            //     "Author: " + record.author,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            //   trailing: Text(
            //     "Category : " + record.category,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
            new DescriptionTextWidget(text: record.status),
          ],
        ),
      ),
    );
  }
//on image share
void _onImageShareButtonPressed(String imageUrl) async {
  print("helo");
var request = await HttpClient().getUrl(Uri.parse(imageUrl));
var response = await request.close();
Uint8List bytes = await consolidateHttpClientResponseBytes(response);
await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
}



//for image download

// void _onImageDownloadButtonPressed() async{
//   // on loading
//   print("onImageSaveVuttonPressed");
//   final  response = await http.get("https://demo.cloudimg.io/width/600/n/https://scaleflex.ultrafast.io/https://jolipage.airstore.io/img.jpg");
//   filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
//   print(filePath);
// }

// new GestureDetector(
//                 child: new CustomToolTip(text: "My Copyable Text"),
//                 onTap: () {},
//               ),

  // Toggle the voted status of one record.
  void _toggleVoted(_LikeRecord record) async {
    final post = record.name;
    int deltalikes = this._isVoted(post) ? -1 : 1;
    try {
      // Update likes via transactions are atomic: no race condition.
      await Firestore.instance.runTransaction(
        (transaction) async {
          final freshSnapshot =
              await transaction.get(record.firestoreDocReference);
          // Get the most fresh record.
          final freshRecord = _LikeRecord.fromSnapshot(freshSnapshot);
          await transaction.update(record.firestoreDocReference,
              {'likes': freshRecord.likes + deltalikes});
        },
        timeout: Duration(seconds: 2),
      );
      // Update local voted status only after transaction is successful.
      this._markVotedStatus(post, !this._isVoted(post));
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Error doing firebase transaction: $e'),
        ),
      );
    }
  }
}

// Custom data class for holding "{name,vote}" records.
class _LikeRecord {
  final String name;
  final int likes;
  final String category;
  final String status;
  final String imageName;
  final String imageUrl;
  final String author;
  final int created;
  // Reference to this record as a firestore document.
  final DocumentReference firestoreDocReference;

  _LikeRecord.fromMap(Map<String, dynamic> map,
      {@required this.firestoreDocReference})
      : assert(map['name'] != null),
        assert(map['likes'] != null),
        name = map['name'],
        likes = map['likes'],
        category = map['category'],
        status = map['status'],
        author = map['author'],
        imageName = map['imageName'],
        imageUrl = map['imageUrl'],
        created = map['created'];

  _LikeRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, firestoreDocReference: snapshot.reference);

  @override
  String toString() => "Record<$name:$likes>";
}

//for a clipboard copy
class CustomToolTip extends StatelessWidget {
  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Tooltip(
          preferBelow: false, message: "Copy", child: new Text(text)),
      onTap: () {
        Clipboard.setData(new ClipboardData(text: text));
        Fluttertoast.showToast(msg: 'Copied in Clipboard');
      },
    );
  }
}

//descriptive
class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
