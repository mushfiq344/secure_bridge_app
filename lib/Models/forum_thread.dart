class ForumThread {
  int id;
  int categoryId;
  int authorId;
  String title;
  bool pinned;
  bool locked;
  int firstPostId;
  int lastPostId;
  int replyCount;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ForumThread(
      {this.id,
      this.categoryId,
      this.authorId,
      this.title,
      this.pinned,
      this.locked,
      this.firstPostId,
      this.lastPostId,
      this.replyCount,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ForumThread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    authorId = json['author_id'];
    title = json['title'];
    pinned = json['pinned'];
    locked = json['locked'];
    firstPostId = json['first_post_id'];
    lastPostId = json['last_post_id'];
    replyCount = json['reply_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
}
