class User{
  int id;

  String name;
  String email;
  int userType;

  User(
      {this.id,
        this.name,
        this.email,
        this.userType,
       });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType= json['user_type'];

  }
}
