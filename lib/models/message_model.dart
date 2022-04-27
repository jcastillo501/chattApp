import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String message;
  late String messageUser;
  late DateTime messageTime;
  late String sendTo;
  late String idFrom;
  late String id;

  Message(
    this.message,
    this.messageUser,
    this.messageTime,
  );

  Message.fromMap(Map<String, dynamic> map) {
    message = map['message'];
    messageUser = map['messageUser'];
    messageTime = (map['messageTime'] as Timestamp).toDate();
    sendTo = map['sendTo'];
    idFrom = map['idFrom'];
    id = map['id'];
  }
}
