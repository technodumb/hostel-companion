class UserModel {
  final String name;
  final String email;
  final String id;
  final String hostel;
  final String roomNo;
  List<DateTime> noFoodDates;
  // contructor
  UserModel({
    required this.hostel,
    required this.roomNo,
    required this.name,
    required this.email,
    required this.id,
    required this.noFoodDates,
  });

  // factory method
  factory UserModel.fromMap(Map<String, dynamic> data) {
    try {
      List<dynamic> noFoodDates = data['noFoodDates'] ?? [];
      List<DateTime> noFoodDatesDateTime = [];
      for (var date in noFoodDates) {
        noFoodDatesDateTime.add(date.toDate());
      }
      return UserModel(
        name: data['name'],
        email: data['email'],
        id: data['id'],
        noFoodDates: noFoodDatesDateTime,
        hostel: data['hostel'],
        roomNo: data['roomNo'],
      );
    } catch (e) {
      print('FromMap: $e');
      return UserModel.empty();
    }
  }

  // method to make GET parameters
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'noFoodDates': noFoodDates,
    };
  }

  static UserModel empty() {
    return UserModel(
      name: '',
      email: '',
      id: '',
      noFoodDates: [],
      hostel: '',
      roomNo: '',
    );
  }
}
