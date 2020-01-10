import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
//Collection refrence
  final CollectionReference collectionReference =
      Firestore.instance.collection('category');

  final CollectionReference collectionReferenceFoods =
      Firestore.instance.collection('Foods');

  Future UpdateSection(String name, String image) async {
    return await collectionReference
        .document()
        .setData({'name': name, 'image': image});
  }

  Future UpdateFoods(
      String name, String image, String price, String sectionName) async {
    return await collectionReferenceFoods.document().setData(
        {'Name': name, 'Image': image, 'Price': price, 'MenuId': sectionName});
  }

  orderUpdateData(selectedDoc, newValue) {
    Firestore.instance
        .collection('Requests')
        .document(selectedDoc)
        .updateData(newValue);
  }
  orderDelete(docID){
    Firestore.instance
        .collection('Requests').document(docID).delete();
  }
}
