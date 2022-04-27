import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final SharedPreferences pref =
  //     SharedPreferences.getInstance() as SharedPreferences;

  String email = '';
  String password = '';
  String status = '';
  bool isLoading = false;
  UserModel userModel = UserModel();

  // GoogleSignInAccount? currentUser;

  Future signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    notifyListeners();
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential userMail = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = userMail.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<bool> checkIfEmailInUse(String? email) async {
    try {
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);
      notifyListeners();
      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  Future<String?> signinGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      firebaseUser = (await _auth.signInWithCredential(credential)).user;

      await db.collection('users').doc(firebaseUser?.uid).set({
        'nombres': firebaseUser?.displayName,
        'telefono': firebaseUser?.phoneNumber,
        'id': firebaseUser?.uid,
        'createAd': DateTime.now().microsecondsSinceEpoch.toString(),
        'chattingWith': null,
        'status': 'online'
      });
      // await pref.setString('id', userModel.userId);
      // await pref.setString('names', userModel.userName);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
    notifyListeners();
    return null;
  }

  Future<void> signOutGoogle() async {
    await db.collection('users').doc(firebaseUser?.uid).update(
      {'status': 'offline'},
    );

    await _googleSignIn.signOut();
    await _auth.signOut();

    notifyListeners();
  }
}
