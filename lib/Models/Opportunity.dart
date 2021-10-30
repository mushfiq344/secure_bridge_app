class Opportunity {
  int id;
  int createdBy;
  String title;
  String subTitle;
  String description;
  String opportunityDate;
  int duration;
  String reward;

  String type;
  String coverImage;
  String iconImage;
  String createdAt;
  String updatedAt;
  String slug;
  int isActive;
  bool show = false;

  Opportunity(
      {this.id,
      this.createdBy,
      this.title,
      this.subTitle,
      this.description,
      this.opportunityDate,
      this.duration,
      this.reward,
      this.type,
      this.coverImage,
      this.iconImage,
      this.createdAt,
      this.updatedAt,
      this.slug,
      this.isActive});

  Opportunity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    title = json['title'];
    subTitle = json['subtitle'];
    description = json['description'];
    opportunityDate = json['opportunity_date'];
    duration = json['duration'];
    reward = json["reward"];
    type = json['type'];
    coverImage = json['cover_image'];
    iconImage = json['icon_image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slug = json['slug'];
  }
}
