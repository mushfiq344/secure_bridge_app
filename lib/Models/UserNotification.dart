class UserNotification {
  int id;
  int type;
  int status;
  int isDeleted;
  String title;
  String message;
  String notifiableType;
  int notifiableId;

  UserNotification({
    this.id,
    this.type,
    this.status,
    this.isDeleted,
    this.title,
    this.message,
    this.notifiableType,
    this.notifiableId,
  });

  UserNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    title = json['title'];
    message = json['message'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
  }
}
