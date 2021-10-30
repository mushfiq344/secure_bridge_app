import 'dart:convert';

class LoginBody {
  final String email;
  final String password;

  LoginBody(this.email, this.password);

  LoginBody.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, String> toJson() => {
        'email': email,
        'password': password,
      };
}

class UserBody {
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  final String date_of_birth;
  final String gender;
  final String education;
  final String familiarity;
  final String latitude;
  final String longitude;
  final int admin_area_l1_id;
  final int admin_area_l2_id;
  final int admin_area_l3_id;
  final int admin_area_l4_id;
  final int admin_area_l4b_id;
  final String password;
  final String password_confirmation;
  final String image_name_with_extension;
  final String image;

  UserBody(
      this.first_name,
      this.last_name,
      this.email,
      this.phone_number,
      this.date_of_birth,
      this.gender,
      this.education,
      this.familiarity,
      this.latitude,
      this.longitude,
      this.admin_area_l1_id,
      this.admin_area_l2_id,
      this.admin_area_l3_id,
      this.admin_area_l4_id,
      this.admin_area_l4b_id,
      this.password,
      this.password_confirmation,
      this.image_name_with_extension,
      this.image);

  UserBody.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        last_name = json['last_name'],
        email = json['email'],
        phone_number = json['phone_number'],
        date_of_birth = json['date_of_birth'],
        gender = json['gender'],
        education = json['education'],
        familiarity = json['familiarity'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        admin_area_l1_id = int.parse(json['admin_area_l1_id']),
        admin_area_l2_id = int.parse(json['admin_area_l2_id']),
        admin_area_l3_id = int.parse(json['admin_area_l3_id']),
        admin_area_l4_id = int.parse(json['admin_area_l4_id']),
        admin_area_l4b_id = int.parse(json['admin_area_l4b_id']),
        password = json['password'],
        password_confirmation = json['password_confirmation'],
        image_name_with_extension = json['image_name_with_extension'],
        image = json['image'];

  Map<String, String> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'phone_number': phone_number,
        'date_of_birth': date_of_birth,
        'gender': gender,
        'education': education,
        'familiarity': familiarity,
        'latitude': latitude,
        'longitude': longitude,
        'admin_area_l1_id': admin_area_l1_id.toString(),
        'admin_area_l2_id': admin_area_l2_id.toString(),
        'admin_area_l3_id': admin_area_l3_id.toString(),
        'admin_area_l4_id': admin_area_l4_id.toString(),
        'admin_area_l4b_id': admin_area_l4b_id.toString(),
        'password': password,
        'password_confirmation': password_confirmation,
        'image_name_with_extension': image_name_with_extension,
        'image': image,
      };
}

class RegistrationBody {
  final UserBody user;

  RegistrationBody(this.user);

  RegistrationBody.fromJson(Map<String, dynamic> json) : user = json['user'];

  Map<String, UserBody> toJson() => {'user': user};
}
