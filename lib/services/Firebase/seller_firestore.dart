import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:graduation_project/Models/seller_model.dart';
import 'package:image_picker/image_picker.dart';

import 'user_auth.dart';

class SellerFirestore extends ChangeNotifier {
  final CollectionReference _sellerCollection =
      FirebaseFirestore.instance.collection('Sellers');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  SellerModel? seller;
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

  Future<void> addSeller({
    uid,
    username,
    email,
    category,
    phoneNumber,
    projectName,
  }) async {
    Map<String, dynamic> userData = {
      'sellerUID': uid,
      'username': username,
      'email': email,
      'profilePicture': '',
      'phoneNumber': phoneNumber,
      'projectName': projectName,
      'category': category,
      'chats': [],
    };
    DocumentReference docRef = await _sellerCollection.add(userData);
    String sellerId = docRef.id;
    await _sellerCollection.doc(sellerId).update({'sellerId': sellerId});
  }

  Future<bool> isSeller(String email) async {
    try {
      QuerySnapshot querySnapshot = await _sellerCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // ignore: avoid_print
      print('Error checking user existence: $e');
      return false;
    }
  }

  Future<void> loadSellerData() async {
    final User user = UserAuth().currentUser;
    QuerySnapshot querySnapshot = await _sellerCollection
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    seller = SellerModel.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>);
    notifyListeners();
  }

  Future<String?> getProjectNameBySellerId(String sellerId) async {
    try {
      QuerySnapshot querySnapshot = await _sellerCollection
          .where('sellerId', isEqualTo: sellerId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> sellerData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return sellerData['projectName'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting projectName: $e');
      return null;
    }
  }

  Future<List<SellerModel>> getAllSellers() async {
    try {
      QuerySnapshot querySnapshot = await _sellerCollection.get();
      List<SellerModel> sellers = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        sellers.add(SellerModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return sellers;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting sellers: $e');
      return [];
    }
  }

  Future<List<SellerModel>> getSellersByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot =
          await _sellerCollection.where('category', isEqualTo: category).get();
      List<SellerModel> sellers = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        sellers.add(SellerModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return sellers;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting sellers by category: $e');
      return [];
    }
  }

  Future<void> updateSellerData(
      {String? path,
      String? username,
      String? phoneNumber,
      List<dynamic>? chats}) async {
    final User user = UserAuth().currentUser;
    final docSnap = await _sellerCollection
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    final doc = docSnap.docs.first;
    if (path != null) {
      doc.reference.update({'profilePicture': path});
    }
    if (username != null) {
      doc.reference.update({'username': username});
    }
    if (phoneNumber != null) {
      doc.reference.update({'phoneNumber': phoneNumber});
    }
    if (chats != null) {
      doc.reference.update({'chats': chats});
    }
    loadSellerData();
  }

  Future<void> updateSellerByID(
      {required String? sellerID, List<dynamic>? chats}) async {
    final docSnap = await _sellerCollection
        .where('sellerId', isEqualTo: sellerID)
        .limit(1)
        .get();
    final doc = docSnap.docs.first;
    if (chats != null) {
      doc.reference.update({'chats': chats});
    }
  }

  final picker = ImagePicker();
  XFile? _image;
  XFile? get getImage => _image;

  Future pickGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage();
    }
  }

  Future pickCameraImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage();
    }
  }

  void uploadImage() async {
    final User user = UserAuth().currentUser;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('/profileImage${user.uid}');
    firebase_storage.UploadTask uploadTask =
        ref.putFile(File(getImage!.path).absolute);
    await Future.value(uploadTask);
    final String newURL = await ref.getDownloadURL();
    updateSellerData(path: newURL);
  }
}
