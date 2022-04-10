class ForumPost {
  int id;
  int threadId;
  int authorId;
  String content;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ForumPost(
      {this.id,
      this.threadId,
      this.authorId,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ForumPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    threadId = json['thread_id'];
    authorId = json['author_id'];
    content = json['content'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
}
