import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:graduation_project/Models/seller_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/buyer_model.dart';
import 'user_auth.dart';

class BuyersFirestore extends ChangeNotifier {
  final CollectionReference _buyerCollection =
      FirebaseFirestore.instance.collection('Buyers');
  final CollectionReference _sellerCollection =
      FirebaseFirestore.instance.collection('Sellers');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  BuyerModel? buyer;
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

  Future<void> addBuyer({username, email, uid}) async {
    Map<String, dynamic> userData = {
      'buyerUID': uid,
      'username': username,
      'email': email,
      'profilePicture': '',
      'cart': [],
      'chats': [],
    };
    DocumentReference docRef = await _buyerCollection.add(userData);
    String buyerId = docRef.id;
    await _buyerCollection.doc(buyerId).update({'buyerId': buyerId});
  }

  Future<bool> isBuyer(String email) async {
    try {
      QuerySnapshot querySnapshot = await _buyerCollection
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

  Future<void> loadBuyerData() async {
    final User user = UserAuth().currentUser;
    QuerySnapshot querySnapshot = await _buyerCollection
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    buyer = BuyerModel.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> updateBuyerData(
      {String? path, String? username, List<dynamic>? chats}) async {
    final User user = UserAuth().currentUser;
    final docSnap = await _buyerCollection
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
    if (chats != null) {
      doc.reference.update({'chats': chats});
    }
    loadBuyerData();
  }

  Future<void> updateBuyerByID(
      {required String? buyerID, List<dynamic>? chats}) async {
    final docSnap = await _buyerCollection
        .where('buyerId', isEqualTo: buyerID)
        .limit(1)
        .get();
    final doc = docSnap.docs.first;
    if (chats != null) {
      doc.reference.update({'chats': chats});
    }
  }

  Future<dynamic> getPersonByID({required String id}) async {
    final buyerSnapshot =
        await _buyerCollection.where('buyerUID', isEqualTo: id).limit(1).get();

    if (buyerSnapshot.docs.isNotEmpty) {
      return BuyerModel.fromMap(
          buyerSnapshot.docs.first.data() as Map<String, dynamic>);
    }

    final sellerSnapshot = await _sellerCollection
        .where('sellerUID', isEqualTo: id)
        .limit(1)
        .get();

    if (sellerSnapshot.docs.isNotEmpty) {
      return SellerModel.fromMap(
          sellerSnapshot.docs.first.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<BuyerModel> getStudentByID({required studentID}) async {
    final querySnapshot = await _buyerCollection
        .where('studentID', isEqualTo: studentID)
        .limit(1)
        .get();
    return BuyerModel.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>);
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
    updateBuyerData(path: newURL);
  }
}
