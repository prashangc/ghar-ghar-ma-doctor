class GetPackageFamilySize {
  Packagefee? packagefee;
  String? message;

  GetPackageFamilySize({this.packagefee, this.message});

  GetPackageFamilySize.fromJson(Map<String, dynamic> json) {
    packagefee = json['packagefee'] != null
        ? Packagefee.fromJson(json['packagefee'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (packagefee != null) {
      data['packagefee'] = packagefee!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Packagefee {
  int? id;
  int? packageId;
  int? familySize;
  int? oneRegistrationFee;
  int? twoContinuationFee;
  int? threeContinuationFee;
  int? oneMonthlyFee;
  int? twoMonthlyFee;
  int? threeMonthlyFee;
  String? createdAt;
  String? updatedAt;

  Packagefee(
      {this.id,
      this.packageId,
      this.familySize,
      this.oneRegistrationFee,
      this.twoContinuationFee,
      this.threeContinuationFee,
      this.oneMonthlyFee,
      this.twoMonthlyFee,
      this.threeMonthlyFee,
      this.createdAt,
      this.updatedAt});

  Packagefee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    familySize = json['family_size'];
    oneRegistrationFee = json['one_registration_fee'];
    twoContinuationFee = json['two_continuation_fee'];
    threeContinuationFee = json['three_continuation_fee'];
    oneMonthlyFee = json['one_monthly_fee'];
    twoMonthlyFee = json['two_monthly_fee'];
    threeMonthlyFee = json['three_monthly_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['family_size'] = familySize;
    data['one_registration_fee'] = oneRegistrationFee;
    data['two_continuation_fee'] = twoContinuationFee;
    data['three_continuation_fee'] = threeContinuationFee;
    data['one_monthly_fee'] = oneMonthlyFee;
    data['two_monthly_fee'] = twoMonthlyFee;
    data['three_monthly_fee'] = threeMonthlyFee;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
