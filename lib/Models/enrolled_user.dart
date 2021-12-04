class EnrolledUser {
  String userName;
  String profileName;
  int userId;
  String userPhoto;
  String userAddress;
  int enrollmentId;
  int opportunityId;
  int enrollmentCode;
  int enrollmentStatus;

  EnrolledUser({
    this.userName,
    this.profileName,
    this.userId,
    this.userPhoto,
    this.userAddress,
    this.enrollmentId,
    this.opportunityId,
    this.enrollmentCode,
    this.enrollmentStatus,
  });

  EnrolledUser.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    profileName = json['profile_name'];
    userPhoto = json['user_photo'];
    userId = json['user_id'];
    userAddress = json['user_address'];
    enrollmentId = json['enrollment_id'];
    opportunityId = json['opportunity_id'];
    enrollmentCode = json['enrollment_code'];
    enrollmentStatus = json["enrollment_status"];
  }
}
