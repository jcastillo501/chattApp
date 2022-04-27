import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<UserModel> userList = [];
  int indexs = 0;
  // List<Map> userChats = [];
  Future getContats(BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> contats = (await db
        .collection('users')
        .where('id', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get());
    for (DocumentSnapshot item in contats.docs) {
      Map<String, dynamic> listuser = item.data() as Map<String, dynamic>;
      UserModel usr = UserModel.fromMap(listuser);
      userList.add(usr);
    }
    notifyListeners();
  }
}
