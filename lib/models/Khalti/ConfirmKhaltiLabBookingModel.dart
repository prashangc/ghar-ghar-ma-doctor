class ConfirmKhaltiLabBookingModel {
  String? token;
  int? amount;
  int? id;

  ConfirmKhaltiLabBookingModel({this.token, this.amount, this.id});

  ConfirmKhaltiLabBookingModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    amount = json['amount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['amount'] = amount;
    data['id'] = id;
    return data;
  }
}
