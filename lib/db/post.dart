import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostService {
  Firestore _firestore = Firestore.instance;
  String ref = 'Posts';
  //create category
  //String PostName, String brand, String category,int status,int author, List votes,String image
  void uploadPost(String imageUrl, String PostName, String category, String status, String author, int likes,String imageName) {
    var id = Uuid();
    String postId = id.v1();
    _firestore.collection(ref).document(postId).setData({
      imageUrl: 'imageUrl',
      'id': postId,
      'imageUrl': imageUrl,
      'imageName': imageName,
      'name': PostName,
      'category': category,
      'author': author,
      'status': status,
      'likes': likes,
      'created': DateTime.now().millisecondsSinceEpoch
    });
  }

  void updatePost(docId, String imageUrl, String PostName,String category, String status, String author, List likes,String imageName) {
    _firestore.collection(ref).document(docId).updateData({
      'id': docId,
      'imageUrl': imageUrl,
      'name': PostName,
      'category': category,
      'author': author,
      'status': status,
      'likes': likes,
      'imageName':imageName,
      'created': DateTime.now().millisecondsSinceEpoch
    });
  }
  void deletePost(docId,String imageName) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
    });
    FirebaseStorage.instance.ref().child(imageName).delete().then((_) => print('Successfully deleted  storage item' ));
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

