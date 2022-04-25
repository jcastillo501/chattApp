import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String chatId = '';
  List<ChatModel> chatList = [];

  // List<Map> userChats = [];
  Future getChats(BuildContext context) async {
    QuerySnapshot chats = await db.collection('chats').get();
    for (DocumentSnapshot item in chats.docs) {
      Map<String, dynamic> listChat = item.data() as Map<String, dynamic>;
      ChatModel cht = ChatModel.fromMap(listChat);
      chatList.add(cht);
    }
    notifyListeners();
  }

  Future generateChatId(String? idUser, String idContact) async {
    chatId = idUser! + '_' + idContact;
  }
}
