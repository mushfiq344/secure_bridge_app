class Plan {
  int id;

  String title;
  String description;
  double amount;
  int duration;
  int mode;
  int type;

  Plan({this.id, this.title, this.description, this.duration, this.mode});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    amount = double.parse(json['amount']);
    duration = json['duration'];
    mode = json['mode'];
  }
}
