import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:graduation_project/Models/item_model.dart';

class ItemFirestore extends ChangeNotifier {
  final CollectionReference _itemCollection =
      FirebaseFirestore.instance.collection('Items');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  ItemModel? item;
  List<dynamic> items = [];
  bool isLoading = false;
  String errorMessage = '';

  set setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  set setMessage(String value) {
    errorMessage = value;
    notifyListeners();
  }

  Future<void> addItem({
    price,
    description,
    title,
    image,
    sellerId,
  }) async {
    Map<String, dynamic> itemData = {
      'price': price,
      'description': description,
      'image': image,
      'sellerId': sellerId,
      'title': title,
    };
    DocumentReference docRef = await _itemCollection.add(itemData);
    String itemId = docRef.id;
    await _itemCollection.doc(itemId).update({'itemId': itemId});
  }

  Stream<List<ItemModel>> getItemsForSellerStream(String sellerId) {
    return _itemCollection
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ItemModel.fromMap(data);
      }).toList();
    });
  }

  Stream<int> getItemCountForSellerStream(String sellerId) {
    return _itemCollection
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _itemCollection.doc(itemId).delete();
      // ignore: avoid_print
      print('Item deleted successfully.');
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting item: $e');
      // Handle the error as needed
    }
  }

  void updateItems(List<dynamic> updatedItems) {
    items = updatedItems;
    notifyListeners();
  }

//   // * Profile Image
//   final picker = ImagePicker();
//   XFile? _image;
//   XFile? get getImage => _image;

//   Future pickGalleryImage() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
//     if (pickedFile != null) {
//       _image = XFile(pickedFile.path);
//       uploadImage();
//     }
//   }

//   Future pickCameraImage() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
//     if (pickedFile != null) {
//       _image = XFile(pickedFile.path);
//       uploadImage();
//     }
//   }

//   void uploadImage() async {
//     final User user = UserAuth().currentUser;
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref('/profileImage${user.uid}');
//     firebase_storage.UploadTask uploadTask =
//         ref.putFile(File(getImage!.path).absolute);
//     await Future.value(uploadTask);
//     final String newURL = await ref.getDownloadURL();
//     user.email?.contains('std') ?? false
//         ? updateStudentData(path: newURL)
//         : updateInstructorData(path: newURL);
//   }
}
