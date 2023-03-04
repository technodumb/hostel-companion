class UsernameModel {
  String username;
  String email;
  bool didReset;
  UsernameModel({
    required this.username,
    required this.email,
    required this.didReset,
  });
  factory UsernameModel.fromMap(Map<String, dynamic> data) {
    return UsernameModel(
      username: data['username'],
      email: data['email'],
      didReset: data['didReset'],
    );
  }
}
