import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class UserAuth extends ChangeNotifier {
  // * Create user
  UserModel userData = UserModel();

  set setUserEmail(String? email) => userData.email = email ?? '';
  set setUserPassword(String? password) => userData.password = password ?? '';

  // * Create Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void sendVerificationEmail() async {
    var actionCodeSettings = ActionCodeSettings(
      url: 'https://test-ee6e0.firebaseapp.com',
      handleCodeInApp: false,
    );
    await _auth.currentUser?.sendEmailVerification(actionCodeSettings);
  }

  Future signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      sendVerificationEmail();
      return userCredential.user;
    } catch (e) {
      setMessage = '$e';
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      setMessage = '$e';
      return null;
    }
  }

  Future<User?> loginAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      setMessage = '$e';
      return null;
    }
  }

  Future<void> resetPassword(String? email) async {
    try {
      await _auth.sendPasswordResetEmail(email: '$email');
    } on SocketException {
      setLoading = false;
      setMessage = 'No Internet';
    } on FirebaseAuthException catch (error) {
      setLoading = false;
      setMessage = error.message ?? '';
    } catch (e) {
      setLoading = false;
      setMessage = e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User get currentUser => _auth.currentUser!;

  Stream<User?> get userStream => _auth.authStateChanges();
}
