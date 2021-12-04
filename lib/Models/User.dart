import 'package:secure_bridges_app/Models/Profile.dart';

class User {
  int id;

  String name;
  String email;
  String profileImage;
  int userType;

  User({this.id, this.name, this.email, this.profileImage, this.userType});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType = json['user_type'];
    profileImage = json['profile_image'];
  }
}
