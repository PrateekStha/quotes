import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';
  //create category
  void createCategory(String name) {
    var id = Uuid();
    String categoryId = id.v1();
    _firestore
        .collection(ref)
        .document(categoryId)
        .setData({'id': categoryId, 'category': name});
  }

  void updateCategory(String name, docId) {
    _firestore
        .collection(ref)
        .document(docId)
        .updateData({'id': docId, 'category': name});
  }

  void deleteCategory(docId) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
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
