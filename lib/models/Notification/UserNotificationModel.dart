class UserNotificationModel {
  int? id;
  int? userId;
  String? title;
  String? body;
  String? image;
  String? watched;
  String? type;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  UserNotificationModel(
      {this.id,
      this.userId,
      this.title,
      this.body,
      this.image,
      this.watched,
      this.type,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  UserNotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    watched = json['watched'];
    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['body'] = body;
    data['image'] = image;
    data['watched'] = watched;
    data['type'] = type;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
