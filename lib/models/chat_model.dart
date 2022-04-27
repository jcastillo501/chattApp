class ChatModel {
  late String idFrom;
  late String idTo;
  late DateTime timeSend;
  // late String message;
  late String chatId;

  ChatModel(this.idFrom, this.idTo, this.timeSend, this.chatId);

  ChatModel.fromMap(Map<String, dynamic> map) {
    idFrom = map['idFrom'];
    idTo = map['idTo'];
    timeSend = map['timeSend'] as DateTime;
    // message = map['message'];
    chatId = map['chatId'];
  }
}
