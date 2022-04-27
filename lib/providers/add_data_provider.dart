import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFormProvider with ChangeNotifier {
  // GlobalKey<FormState> formkey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String nameCont = '';
  String telf = '';
  bool _isLoading = false;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // bool isValidForm() {
  //   return formkey.currentState?.validate() ?? false;
  // }

  Future addData(String name, String tel) async {
    await db.collection('users').doc(firebaseUser?.uid).set(
      {
        'nombres': nameCont,
        'telefono': telf,
        'id': firebaseUser?.uid,
        'createAd': DateTime.now().microsecondsSinceEpoch.toString(),
        'chattingWith': null,
        'status': 'online'
      },
    );
    notifyListeners();
  }
}
