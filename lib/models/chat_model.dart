class ChatModel {
  late String idFrom;
  late String idTo;
  late String timeSend;
  late String message;

  ChatModel(this.idFrom, this.idTo, this.message, this.timeSend);

  ChatModel.fromMap(Map<String, dynamic> map) {
    idFrom = map['idFrom'];
    idTo = map['idTo'];
    timeSend = map['timeSend'];
    message = map['message'];
  }
}
