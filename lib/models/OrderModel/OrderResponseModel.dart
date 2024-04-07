class OrderResponseModel {
  String? status;
  String? orderNumber;
  int? id;

  OrderResponseModel({this.status, this.orderNumber, this.id});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderNumber = json['order_number'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['order_number'] = orderNumber;
    data['id'] = id;
    return data;
  }
}
