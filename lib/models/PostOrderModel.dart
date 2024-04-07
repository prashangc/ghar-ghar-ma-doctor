class PostOrderModel {
  int? subTotal;
  int? totalAmount;
  int? shippingID;
  String? phone;
  String? paymentMethod;
  String? address;
  List<Orders>? orders;

  PostOrderModel(
      {this.subTotal,
      this.totalAmount,
      this.shippingID,
      this.phone,
      this.paymentMethod,
      this.address,
      this.orders});

  PostOrderModel.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    shippingID = json['shipping_id'];
    phone = json['phone'];
    paymentMethod = json['payment_method'];
    address = json['address'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_total'] = subTotal;
    data['shipping_id'] = shippingID;
    data['total_amount'] = totalAmount;
    data['phone'] = phone;
    data['payment_method'] = paymentMethod;
    data['address'] = address;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  int? quantity;
  int? vendorId;

  Orders({this.id, this.quantity, this.vendorId});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['vendor_id'] = vendorId;
    return data;
  }
}
