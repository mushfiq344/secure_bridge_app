import 'package:secure_bridges_app/utls/constants.dart';

import 'User.dart';

class Opportunity {
  int id;
  User createdBy;
  String title;
  String subTitle;
  String description;
  String opportunityDate;
  int duration;
  String reward;

  int type;
  String coverImage;
  String iconImage;
  String createdAt;
  String updatedAt;
  String slug;
  int isActive;
  int status;
  String location;
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
      this.isActive,
      this.status,
      this.location});

  Opportunity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = User.fromJson(json['created_by']);
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
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slug = json['slug'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    var data = {
      'id': id,
      'title': title,
      'subtitle': subTitle,
      'description': description,
      'opportunity_date': opportunityDate,
      'duration': duration,
      'reward': reward,
      'type': type,
      'status': status,
      'location': location,
    };
    return data;
  }
}
