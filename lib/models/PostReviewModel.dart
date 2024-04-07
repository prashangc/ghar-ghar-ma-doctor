class PostReviewModel {
  String? rating;
  String? comment;
  String? productId;

  PostReviewModel({this.rating, this.comment, this.productId});

  PostReviewModel.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['comment'] = comment;
    data['product_id'] = productId;
    return data;
  }
}
