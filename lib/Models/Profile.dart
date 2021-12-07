class Profile {
  int id;
  int userId;
  String fullName;
  String photo;
  String address;
  int gender;

  Profile(
      {this.id,
      this.userId,
      this.fullName,
      this.photo,
      this.address,
      this.gender});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    photo = json['photo'];
    address = json['address'];
    gender = json['gender'];
  }
}
