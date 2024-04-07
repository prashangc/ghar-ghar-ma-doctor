class GetFaqModel {
  int? id;
  String? slug;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  GetFaqModel(
      {this.id,
      this.slug,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt});

  GetFaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['question'] = question;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
