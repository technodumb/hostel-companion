class UsernameModel {
  String uid;
  String username;
  String email;
  bool didReset;
  UsernameModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.didReset,
  });
  factory UsernameModel.fromMap(Map<String, dynamic> data) {
    if (data == {}) {
      throw UsernameModelException('username-not-found', 'Username not found');
    }
    return UsernameModel(
      username: data['username'],
      email: data['email'],
      didReset: data['didReset'],
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'didReset': didReset,
    };
  }
}

class UsernameModelException implements Exception {
  String message;
  String code;

  UsernameModelException(this.code, this.message);
}
