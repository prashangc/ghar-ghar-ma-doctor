class PostVendorReview {
  int? vendorId;
  String? rating;
  String? comment;

  PostVendorReview({this.vendorId, this.rating, this.comment});

  PostVendorReview.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['vendor_id'] = vendorId;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
