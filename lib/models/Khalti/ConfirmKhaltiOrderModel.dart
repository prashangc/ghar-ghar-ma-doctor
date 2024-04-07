class ConfirmKhaltiOrderModel {
  String? token;
  int? amount;
  int? id;
  String? title;

  ConfirmKhaltiOrderModel({this.token, this.amount, this.id, this.title});

  ConfirmKhaltiOrderModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    amount = json['amount'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['amount'] = amount;
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
