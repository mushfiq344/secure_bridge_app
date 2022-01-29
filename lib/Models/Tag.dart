class Tag {
  int id;
  int opportunityId;
  String title;

  Tag({
    this.id,
    this.opportunityId,
    this.title,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    opportunityId = json['opportunity_id'];
    title = json['title'];
  }
}
