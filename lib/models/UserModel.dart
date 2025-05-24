class UserModel {
  final String email;
  final String password;
  String? uid;

  UserModel({this.uid, required this.email, required this.password});

  set setUid(String uid) {
    this.uid = uid;
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'password': password};
  }
}
