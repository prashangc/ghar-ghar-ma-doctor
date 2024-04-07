class ConfirmKhaltiPackageBookingModel {
  String? token;
  int? amount;
  int? id;
  String? paymentInterval;
  int? prePayStatus;

  ConfirmKhaltiPackageBookingModel(
      {this.token,
      this.amount,
      this.id,
      this.paymentInterval,
      this.prePayStatus});

  ConfirmKhaltiPackageBookingModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    amount = json['amount'];
    id = json['id'];
    paymentInterval = json['payment_interval'];
    prePayStatus = json['prepay_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['amount'] = amount;
    data['id'] = id;
    data['payment_interval'] = paymentInterval;
    data['prepay_status'] = prePayStatus;
    return data;
  }
}
