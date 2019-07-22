import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';
  //create category
  void uploadCategory(String imageUrl, String categoryName, String imageName) {
    var id = Uuid();
    String categoryId = id.v1();
    _firestore.collection(ref).document(categoryId).setData({
      'id': categoryId,
      'imageUrl': imageUrl,
      'category': categoryName,
      'imageName': imageName,
    });
  }

  void deleteCategory(docId,String imageName) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
    });
    FirebaseStorage.instance.ref().child(imageName).delete().then((_) => print('Successfully deleted  storage item' ));
  }

  void updateCategory(String category_id,String imageUrl, String categoryName, String imageName) {
    _firestore
        .collection(ref)
        .document(category_id)
        .updateData({
          'id': category_id,
      'imageUrl': imageUrl,
      'category': categoryName,
      'imageName': imageName,
          });
  }

  

  Future<List<DocumentSnapshot>> getCategories() {
    return _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection(ref)
          .where('category', isEqualTo: suggestion)
          .getDocuments()
          .then((snap) {
        return snap.documents;
      });
      Future totalLength()async{
    var querySnapshot = await _firestore.collection(ref).getDocuments();
      var total = querySnapshot.documents.length;
      print("length is ");
      print(total);
      return total;
  }
}
