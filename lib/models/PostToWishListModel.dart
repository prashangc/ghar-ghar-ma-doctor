class PostToWishListModel {
  String? productId;

  PostToWishListModel({this.productId});

  PostToWishListModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    return data;
  }
}
