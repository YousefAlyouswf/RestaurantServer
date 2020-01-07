import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

//Collection refrence
  final CollectionReference collectionReference =
      Firestore.instance.collection('category');


  Future UpdateSection(String name, String image) async {
    return await collectionReference
        .document()
        .setData({'name': name, 'image': image});
  }
}
