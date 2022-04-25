class UserModel {
  late String userId;
  late String userName;
  late String status;

  UserModel(
      // this.userId,
      // this.userName,
      // this.status
      );

  UserModel.fromMap(Map<String, dynamic> map) {
    userId = map['id'];
    userName = map['nombres'];
    status = map['status'];
  }
}
