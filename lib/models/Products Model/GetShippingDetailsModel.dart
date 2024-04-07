class GetShippingDetailsModel {
  int? id;
  int? maximum;
  int? minimum;
  String? shippingType;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;

  GetShippingDetailsModel(
      {this.id,
      this.maximum,
      this.minimum,
      this.shippingType,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt});

  GetShippingDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maximum = json['maximum'];
    minimum = json['minimum'];
    shippingType = json['shipping_type'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['maximum'] = maximum;
    data['minimum'] = minimum;
    data['shipping_type'] = shippingType;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
