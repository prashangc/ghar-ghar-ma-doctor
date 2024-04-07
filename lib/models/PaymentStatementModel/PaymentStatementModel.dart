class PaymentStatementModel {
  int? id;
  int? userId;
  String? date;
  String? name;
  String? address;
  String? amount;
  String? status;
  String? paymentMethod;
  String? channel;
  String? serviceName;
  String? createdAt;
  String? updatedAt;

  PaymentStatementModel(
      {this.id,
      this.userId,
      this.date,
      this.name,
      this.address,
      this.amount,
      this.status,
      this.paymentMethod,
      this.channel,
      this.serviceName,
      this.createdAt,
      this.updatedAt});

  PaymentStatementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    name = json['name'];
    address = json['address'];
    amount = json['amount'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    channel = json['channel'];
    serviceName = json['service_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['name'] = name;
    data['address'] = address;
    data['amount'] = amount;
    data['status'] = status;
    data['payment_method'] = paymentMethod;
    data['channel'] = channel;
    data['service_name'] = serviceName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
