class CheckProductInStockModel {
  int? id;
  int? stock;

  CheckProductInStockModel({this.id, this.stock});

  CheckProductInStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stock'] = stock;
    return data;
  }
}
