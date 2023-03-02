import 'package:hostel_companion/controllers/provider/food_data.dart';

class UserModel {
  final String name;
  final String email;
  final String id;
  final List<DateTime> noFoodDates;
  // contructor
  UserModel(
      {required this.name,
      required this.email,
      required this.id,
      required this.noFoodDates});

  // factory method
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'],
      email: data['email'],
      id: data['id'],
      noFoodDates: data['noFoodDates'],
    );
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
}

class GlobalStorage {
  UserModel? user = UserModel(
      name: 'name',
      email: 'email',
      id: 'id',
      noFoodDates: [OnlyDate.tomorrow()]);
}
