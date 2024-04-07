class SearchHistoryModel {
  int? id;
  int? userId;
  String? query;
  String? type;
  String? createdAt;
  String? updatedAt;

  SearchHistoryModel(
      {this.id,
      this.userId,
      this.query,
      this.type,
      this.createdAt,
      this.updatedAt});

  SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    query = json['query'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['query'] = query;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
