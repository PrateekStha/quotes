import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Posts';
  //create category
  //String PostName, String brand, String category,int status,int author, List votes,String image
  void uploadPost( String PostName, String category, String status, String author, int likes) {
    var id = Uuid();
    String postId = id.v1();
    _firestore.collection(ref).document(postId).setData({
     
      'id': postId,
      'name': PostName,
      'category': category,
      'author': author,
      'status': status,
      'likes': likes,
      'created': DateTime.now().millisecondsSinceEpoch
    });
  }

  void updatePost(docId, String PostName,String category, String status, String author, int likes) {
    _firestore.collection(ref).document(docId).updateData({
      'id': docId,
      'name': PostName,
      'category': category,
      'author': author,
      'status': status,
      'likes': likes,
      'created': DateTime.now().millisecondsSinceEpoch
    });
  }
  void deletePost(docId) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
    });
  }

  Future<List<DocumentSnapshot>> getPosts() {
    return _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection(ref)
          .where('Post', isEqualTo: suggestion)
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

