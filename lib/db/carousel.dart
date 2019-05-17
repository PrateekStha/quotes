import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
class CarouselService {
  Firestore _firestore = Firestore.instance;
  String ref = 'carousels';
  //create category
  //String carouselName, String brand, String category,int quantity,int price, List Sizes,String image
  void uploadCarousel(String imageUrl, String carouselName, String imageName) {
    var id = Uuid();
    String carouselId = id.v1();
    _firestore.collection(ref).document(carouselId).setData({
      'id': carouselId,
      'imageUrl': imageUrl,
      'name': carouselName,
      'imageName': imageName,
    });
  }

  void deleteCarousel(docId,String imageName) {
    Firestore.instance.collection(ref).document(docId).delete().catchError((e) {
      print(e);
    });
    FirebaseStorage.instance.ref().child(imageName).delete().then((_) => print('Successfully deleted  storage item' ));
  }

  Future<List<DocumentSnapshot>> getCarousel() {
    return _firestore.collection(ref).getDocuments().then((snaps) {
      return snaps.documents;
    });
  }
  Future totalLength()async{
    var querySnapshot = await _firestore.collection(ref).getDocuments();
      var total = querySnapshot.documents.length;
      print("length is ");
      print(total);
      return total;
  }
}
