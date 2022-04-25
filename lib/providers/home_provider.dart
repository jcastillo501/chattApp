import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/user_model.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<UserModel> userList = [];
  // List<Map> userChats = [];
  Future getContats(BuildContext context) async {
    QuerySnapshot contats = await db.collection('users').get();
    for (DocumentSnapshot item in contats.docs) {
      Map<String, dynamic> listuser = item.data() as Map<String, dynamic>;
      UserModel usr = UserModel.fromMap(listuser);
      userList.add(usr);
    }
    notifyListeners();
  }
}
