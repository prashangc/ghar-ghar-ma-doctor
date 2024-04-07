class PaymentModelForFamilyReqApprove {
  String? token;
  int? paymentDays;
  int? amount;
  int? familyId;
  int? userpackageId;

  PaymentModelForFamilyReqApprove(
      {this.token,
      this.paymentDays,
      this.amount,
      this.familyId,
      this.userpackageId});

  PaymentModelForFamilyReqApprove.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    paymentDays = json['payment_days'];
    amount = json['amount'];
    familyId = json['family_id'];
    userpackageId = json['userpackage_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['payment_days'] = paymentDays;
    data['amount'] = amount;
    data['family_id'] = familyId;
    data['userpackage_id'] = userpackageId;
    return data;
  }
}
