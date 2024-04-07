class PaymentDetailsOfPackageWhileReqApprove {
  Userpackage? userpackage;
  num? enrollmentFee;
  num? dailyFee;
  int? paymentDays;
  num? totalPayment;

  PaymentDetailsOfPackageWhileReqApprove(
      {this.userpackage,
      this.enrollmentFee,
      this.dailyFee,
      this.paymentDays,
      this.totalPayment});

  PaymentDetailsOfPackageWhileReqApprove.fromJson(Map<String, dynamic> json) {
    userpackage = json['userpackage'] != null
        ? Userpackage.fromJson(json['userpackage'])
        : null;
    enrollmentFee = json['enrollment_fee'];
    dailyFee = json['daily_fee'];
    paymentDays = json['payment_days'];
    totalPayment = json['total_payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userpackage != null) {
      data['userpackage'] = userpackage!.toJson();
    }
    data['enrollment_fee'] = enrollmentFee;
    data['daily_fee'] = dailyFee;
    data['payment_days'] = paymentDays;
    data['total_payment'] = totalPayment;
    return data;
  }
}

class Userpackage {
  int? id;
  String? slug;
  int? familynameId;
  int? memberId;
  int? packageId;
  int? familyId;
  int? status;
  String? packageStatus;
  int? renewStatus;
  String? bookedDate;
  String? expiryDate;
  int? gracePeriod;
  int? year;
  int? additonalMembers;
  String? createdAt;
  String? updatedAt;
  Familyfee? familyfee;
  List<Payment>? payment;

  Userpackage(
      {this.id,
      this.slug,
      this.familynameId,
      this.memberId,
      this.packageId,
      this.familyId,
      this.status,
      this.packageStatus,
      this.renewStatus,
      this.bookedDate,
      this.expiryDate,
      this.gracePeriod,
      this.year,
      this.additonalMembers,
      this.createdAt,
      this.updatedAt,
      this.familyfee,
      this.payment});

  Userpackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    familynameId = json['familyname_id'];
    memberId = json['member_id'];
    packageId = json['package_id'];
    familyId = json['family_id'];
    status = json['status'];
    packageStatus = json['package_status'];
    renewStatus = json['renew_status'];
    bookedDate = json['booked_date'];
    expiryDate = json['expiry_date'];
    gracePeriod = json['grace_period'];
    year = json['year'];
    additonalMembers = json['additonal_members'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    familyfee = json['familyfee'] != null
        ? Familyfee.fromJson(json['familyfee'])
        : null;
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['familyname_id'] = familynameId;
    data['member_id'] = memberId;
    data['package_id'] = packageId;
    data['family_id'] = familyId;
    data['status'] = status;
    data['package_status'] = packageStatus;
    data['renew_status'] = renewStatus;
    data['booked_date'] = bookedDate;
    data['expiry_date'] = expiryDate;
    data['grace_period'] = gracePeriod;
    data['year'] = year;
    data['additonal_members'] = additonalMembers;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (familyfee != null) {
      data['familyfee'] = familyfee!.toJson();
    }
    if (payment != null) {
      data['payment'] = payment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Familyfee {
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

  Familyfee(
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

  Familyfee.fromJson(Map<String, dynamic> json) {
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

class Payment {
  int? id;
  int? userpackageId;
  String? paymentInterval;
  String? paymentMethod;
  String? paymentDate;
  String? expiryDate;
  int? amount;
  int? graceDays;
  int? prepayStatus;
  int? prepayDays;
  String? createdAt;
  String? updatedAt;
  int? paidmemberId;

  Payment(
      {this.id,
      this.userpackageId,
      this.paymentInterval,
      this.paymentMethod,
      this.paymentDate,
      this.expiryDate,
      this.amount,
      this.graceDays,
      this.prepayStatus,
      this.prepayDays,
      this.createdAt,
      this.updatedAt,
      this.paidmemberId});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userpackageId = json['userpackage_id'];
    paymentInterval = json['payment_interval'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    expiryDate = json['expiry_date'];
    amount = json['amount'];
    graceDays = json['grace_days'];
    prepayStatus = json['prepay_status'];
    prepayDays = json['prepay_days'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paidmemberId = json['paidmember_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userpackage_id'] = userpackageId;
    data['payment_interval'] = paymentInterval;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['expiry_date'] = expiryDate;
    data['amount'] = amount;
    data['grace_days'] = graceDays;
    data['prepay_status'] = prepayStatus;
    data['prepay_days'] = prepayDays;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['paidmember_id'] = paidmemberId;
    return data;
  }
}
