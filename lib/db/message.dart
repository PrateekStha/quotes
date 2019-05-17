import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Messages';
  //create category
  //String MessageName, String brand, String category,int quantity,int price, List Sizes,String image
  void uploadMessage( String authorName, String category, String status, String location) {
    var id = Uuid();
    String MessageId = id.v1();
    _firestore.collection(ref).document(MessageId).setData({
      'id': MessageId,
      'name': authorName,
      'category': category,
      'location': location,
      'status': status,
    });
  }


  void deleteMessage(docId) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
    });
  }

  Future<List<DocumentSnapshot>> getMessages() {
    return _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection(ref)
          .where('Message', isEqualTo: suggestion)
          .getDocuments()
          .then((snap) {
        return snap.documents;
      });
  Future totalLength()async{
    var querySnapshot = await _firestore.collection(ref).getDocuments();
      var total = querySnapshot.documents.length;
      return total;
  }
}

