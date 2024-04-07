class PostGdFeedBack {
  int? rating;
  String? feedback;

  PostGdFeedBack({this.rating, this.feedback});

  PostGdFeedBack.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['feedback'] = feedback;
    return data;
  }
}
