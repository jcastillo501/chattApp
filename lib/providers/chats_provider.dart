// ignore_for_file: unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_chatt/models/chat_model.dart';
// import 'package:digi_chatt/models/chat_model.dart';
import 'package:digi_chatt/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  String chatId = '';
  TextEditingController msg = TextEditingController();
  List<ChatModel> chatList = [];
  List<Message> msgList = [];

  List<Map> userChats = [];
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
    if (idUser!.hashCode <= idContact.hashCode) {
      chatId = '$idUser-$idContact';
    } else {
      chatId = '$idContact-$idUser';
    }

    notifyListeners();
  }

  Future sendMessage(
      TextEditingController messa, String? sendBy, String sendTo) async {
    if (messa.text.isNotEmpty) {
      await db.collection('chats').doc(chatId).collection('messages').doc().set(
        {
          'id': chatId,
          'idFrom': firebaseUser?.uid,
          'message': msg.text.trim(),
          'messageUser': sendBy,
          'sendTo': sendTo,
          'messageTime': DateTime.now(),
        },
        SetOptions(merge: true),
      );
      // messa.clear();
    }
    notifyListeners();
  }

  Future getMessages() async {
    // String docMessajeRef = db.collection('messages').doc().id;
    QuerySnapshot messages = await db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('messageTime', descending: true)
        .where('id', isEqualTo: chatId)
        .get();

    for (DocumentSnapshot item in messages.docs) {
      Map<String, dynamic> listMsg = item.data() as Map<String, dynamic>;
      Message msg = Message.fromMap(listMsg);
      msgList.add(msg);
    }
    // messages.docChanges;
    notifyListeners();
  }

  Future updateMessages() async {
    QuerySnapshot messages = await db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        // .orderBy('messageTime', descending: true)
        .where('messageTime', isEqualTo: DateTime.now())
        .get();

    for (DocumentSnapshot item in messages.docs) {
      Map<String, dynamic> listMsg = item.data() as Map<String, dynamic>;
      Message msg = Message.fromMap(listMsg);
      msgList.add(msg);
    }
    // messages.docChanges;
    notifyListeners();
  }

  Future<void> deleteMessage() async {
    String docMessajeRef = db.collection('messages').doc().id;
    await db
        .collection('messages')
        .doc(docMessajeRef)
        .delete()
        .then((_) => print('Deleted'))
        .catchError((error) => print('fallo al eliminar: $error'));
    notifyListeners();
  }

  Future sendMessageBot() async {
    for (var i = 0; i < 30; i++) {}
  }
}
