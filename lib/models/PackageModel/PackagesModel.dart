class PackagesModel {
  int? id;
  String? slug;
  String? packageType;
  String? description;
  int? type;
  int? visits;
  String? registrationFee;
  String? monthlyFee;
  int? screening;
  int? checkup;
  int? ambulance;
  int? insurance;
  int? insuranceAmount;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? scheduleFlexibility;
  int? scheduleTimes;
  int? tests;
  int? onlineConsultation;
  List<Fees>? fees;

  PackagesModel(
      {this.id,
      this.slug,
      this.type,
      this.packageType,
      this.description,
      this.visits,
      this.registrationFee,
      this.monthlyFee,
      this.screening,
      this.checkup,
      this.ambulance,
      this.insurance,
      this.insuranceAmount,
      this.order,
      this.createdAt,
      this.updatedAt,
      this.scheduleFlexibility,
      this.scheduleTimes,
      this.onlineConsultation,
      this.tests,
      this.fees});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    type = json['type'];
    packageType = json['package_type'];
    description = json['description'];
    screening = json['screening'];
    checkup = json['checkup'];
    ambulance = json['ambulance'];
    insurance = json['insurance'];
    visits = json['visits'];
    registrationFee = json['registration_fee'];
    monthlyFee = json['monthly_fee'];
    insuranceAmount = json['insurance_amount'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    scheduleFlexibility = json['schedule_flexibility'];
    scheduleTimes = json['schedule_times'];
    tests = json['tests'];
    onlineConsultation = json['online_consultation'];
    if (json['fees'] != null) {
      fees = <Fees>[];
      json['fees'].forEach((v) {
        fees!.add(Fees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['type'] = type;
    data['package_type'] = packageType;
    data['description'] = description;
    data['screening'] = screening;
    data['checkup'] = checkup;
    data['ambulance'] = ambulance;
    data['insurance'] = insurance;
    data['visits'] = visits;
    data['registration_fee'] = registrationFee;
    data['monthly_fee'] = monthlyFee;
    data['insurance_amount'] = insuranceAmount;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['schedule_flexibility'] = scheduleFlexibility;
    data['schedule_times'] = scheduleTimes;
    data['online_consultation'] = onlineConsultation;
    data['tests'] = tests;
    if (fees != null) {
      data['fees'] = fees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fees {
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

  Fees(
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

  Fees.fromJson(Map<String, dynamic> json) {
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
