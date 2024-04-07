class IndividualPackagesListModel {
  MyPackage? myPackage;
  int? monthCount;
  int? remainingDays;
  int? completedDays;
  bool? prepay;
  String? extendedDate;
  bool? expire;

  IndividualPackagesListModel(
      {this.myPackage,
      this.monthCount,
      this.remainingDays,
      this.completedDays,
      this.prepay,
      this.extendedDate,
      this.expire});

  IndividualPackagesListModel.fromJson(Map<String, dynamic> json) {
    myPackage =
        json['package'] != null ? MyPackage.fromJson(json['package']) : null;
    monthCount = json['month_count'];
    remainingDays = json['remainingDays'];
    completedDays = json['completedDays'];
    prepay = json['prepay'];
    extendedDate = json['extended_date'];
    expire = json['expire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myPackage != null) {
      data['package'] = myPackage!.toJson();
    }
    data['month_count'] = monthCount;
    data['remainingDays'] = remainingDays;
    data['completedDays'] = completedDays;
    data['prepay'] = prepay;
    data['extended_date'] = extendedDate;
    data['expire'] = expire;
    return data;
  }
}

class MyPackage {
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
  int? year;
  int? additonalMembers;
  int? gracePeriod;
  String? createdAt;
  String? updatedAt;
  String? activatedDate;
  Familyname? familyname;
  Package? package;
  Fees? familyfee;
  List<Dates>? dates;
  List<Payment>? payment;
  List<Requests>? requests;

  MyPackage(
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
      this.createdAt,
      this.updatedAt,
      this.year,
      this.additonalMembers,
      this.familyname,
      this.package,
      this.familyfee,
      this.dates,
      this.activatedDate,
      this.payment,
      this.requests});

  MyPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    familynameId = json['familyname_id'];
    packageId = json['package_id'];
    familyId = json['family_id'];
    memberId = json['member_id'];
    status = json['status'];
    packageStatus = json['package_status'];
    renewStatus = json['renew_status'];
    bookedDate = json['booked_date'];
    year = json['year'];
    additonalMembers = json['additonal_members'];
    expiryDate = json['expiry_date'];
    activatedDate = json['activated_date'];
    gracePeriod = json['grace_period'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    familyname = json['familyname'] != null
        ? Familyname.fromJson(json['familyname'])
        : null;
    package =
        json['package'] != null ? Package.fromJson(json['package']) : null;
    familyfee =
        json['familyfee'] != null ? Fees.fromJson(json['familyfee']) : null;
    if (json['dates'] != null) {
      dates = <Dates>[];
      json['dates'].forEach((v) {
        dates!.add(Dates.fromJson(v));
      });
    }
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(Payment.fromJson(v));
      });
    }
    if (json['requests'] != null) {
      requests = <Requests>[];
      json['requests'].forEach((v) {
        requests!.add(Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['familyname_id'] = familynameId;
    data['package_id'] = packageId;
    data['family_id'] = familyId;
    data['status'] = status;
    data['member_id'] = memberId;
    data['package_status'] = packageStatus;
    data['renew_status'] = renewStatus;
    data['booked_date'] = bookedDate;
    data['expiry_date'] = expiryDate;
    data['activated_date'] = activatedDate;
    data['grace_period'] = gracePeriod;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['year'] = year;
    data['additonal_members'] = additonalMembers;
    if (familyname != null) {
      data['familyname'] = familyname!.toJson();
    }
    if (package != null) {
      data['package'] = package!.toJson();
    }
    if (familyfee != null) {
      data['familyfee'] = familyfee!.toJson();
    }
    if (dates != null) {
      data['dates'] = dates!.map((v) => v.toJson()).toList();
    }
    if (payment != null) {
      data['payment'] = payment!.map((v) => v.toJson()).toList();
    }
    if (requests != null) {
      data['requests'] = requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  int? id;
  int? memberId;
  int? userpackageId;
  int? screeningdateId;
  String? date;
  String? time;
  int? status;
  String? createdAt;
  String? updatedAt;

  Requests(
      {this.id,
      this.memberId,
      this.userpackageId,
      this.screeningdateId,
      this.date,
      this.time,
      this.status,
      this.createdAt,
      this.updatedAt});

  Requests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    userpackageId = json['userpackage_id'];
    screeningdateId = json['screeningdate_id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['userpackage_id'] = userpackageId;
    data['screeningdate_id'] = screeningdateId;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Familyname {
  int? id;
  int? primaryMemberId;
  int? onlineConsultation;
  String? familyName;
  String? createdAt;
  String? updatedAt;
  Primary? primary;

  Familyname(
      {this.id,
      this.primaryMemberId,
      this.familyName,
      this.createdAt,
      this.onlineConsultation,
      this.updatedAt,
      this.primary});

  Familyname.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryMemberId = json['primary_member_id'];
    familyName = json['family_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    onlineConsultation = json['online_consultation'];
    primary =
        json['primary'] != null ? Primary.fromJson(json['primary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['primary_member_id'] = primaryMemberId;
    data['family_name'] = familyName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (primary != null) {
      data['primary'] = primary!.toJson();
    }
    return data;
  }
}

class Primary {
  int? id;
  int? memberId;
  String? gender;
  String? address;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? dob;
  String? bloodGroup;
  String? country;
  String? weight;
  String? height;
  String? slug;
  String? memberType;
  String? bp;
  String? bpUpdatedDate;
  String? heartRate;
  String? stepsCount;
  String? createdAt;
  String? updatedAt;
  Member? member;

  Primary(
      {this.id,
      this.memberId,
      this.gender,
      this.address,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.dob,
      this.bloodGroup,
      this.country,
      this.weight,
      this.height,
      this.slug,
      this.memberType,
      this.bp,
      this.bpUpdatedDate,
      this.heartRate,
      this.stepsCount,
      this.createdAt,
      this.updatedAt,
      this.member});

  Primary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    gender = json['gender'];
    address = json['address'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    dob = json['dob'];
    bloodGroup = json['blood_group'];
    country = json['country'];
    weight = json['weight'];
    height = json['height'];
    slug = json['slug'];
    memberType = json['member_type'];
    bp = json['bp'];
    bpUpdatedDate = json['bp_updated_date'];
    heartRate = json['heart_rate'];
    stepsCount = json['steps_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['gender'] = gender;
    data['address'] = address;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['dob'] = dob;
    data['blood_group'] = bloodGroup;
    data['country'] = country;
    data['weight'] = weight;
    data['height'] = height;
    data['slug'] = slug;
    data['member_type'] = memberType;
    data['bp'] = bp;
    data['bp_updated_date'] = bpUpdatedDate;
    data['heart_rate'] = heartRate;
    data['steps_count'] = stepsCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    return data;
  }
}

class Member {
  int? id;
  int? globalFormId;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;

  String? referralLink;

  Member(
      {this.id,
      this.globalFormId,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.createdAt,
      this.updatedAt,
      this.referralLink});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['name'] = name;
    data['phone'] = phone;
    data['role'] = role;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['referral_link'] = referralLink;
    return data;
  }
}

class Package {
  int? id;
  String? slug;
  int? type;
  String? packageType;
  String? description;
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
  int? onlineConsultation;
  List<Fees>? fees;

  Package(
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
      this.fees});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    type = json['type'];
    packageType = json['package_type'];
    description = json['description'];
    visits = json['visits'];
    registrationFee = json['registration_fee'];
    monthlyFee = json['monthly_fee'];
    screening = json['screening'];
    checkup = json['checkup'];
    ambulance = json['ambulance'];
    insurance = json['insurance'];
    insuranceAmount = json['insurance_amount'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    scheduleFlexibility = json['schedule_flexibility'];
    scheduleTimes = json['schedule_times'];
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
    data['visits'] = visits;
    data['registration_fee'] = registrationFee;
    data['monthly_fee'] = monthlyFee;
    data['screening'] = screening;
    data['checkup'] = checkup;
    data['ambulance'] = ambulance;
    data['insurance'] = insurance;
    data['insurance_amount'] = insuranceAmount;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['schedule_flexibility'] = scheduleFlexibility;
    data['schedule_times'] = scheduleTimes;
    data['online_consultation'] = onlineConsultation;
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

class Dates {
  int? id;
  int? userpackageId;
  int? screeningId;
  String? screeningDate;
  String? screeningTime;
  String? labreportDate;
  String? doctorvisitDate;
  String? doctorreportDate;
  String? status;
  int? consultationType;
  int? rescheduleStatus;
  int? additionalScreeningStatus;
  String? additionalScreeningDate;
  String? additionalScreeningTime;
  String? createdAt;
  String? updatedAt;
  String? doctorvisitTime;
  int? isVerified;
  Screening? screening;
  List<Employees>? employees;
  List<Reports>? reports;
  List<Online>? online;
  Dates(
      {this.id,
      this.userpackageId,
      this.screeningId,
      this.screeningDate,
      this.screeningTime,
      this.labreportDate,
      this.doctorvisitDate,
      this.doctorreportDate,
      this.status,
      this.consultationType,
      this.rescheduleStatus,
      this.additionalScreeningStatus,
      this.additionalScreeningDate,
      this.additionalScreeningTime,
      this.createdAt,
      this.updatedAt,
      this.doctorvisitTime,
      this.isVerified,
      this.screening,
      this.employees,
      this.reports,
      this.online});
  Dates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userpackageId = json['userpackage_id'];
    screeningId = json['screening_id'];
    screeningDate = json['screening_date'];
    screeningTime = json['screening_time'];
    labreportDate = json['labreport_date'];
    doctorvisitDate = json['doctorvisit_date'];
    doctorreportDate = json['doctorreport_date'];
    status = json['status'];
    consultationType = json['consultation_type'];
    rescheduleStatus = json['reschedule_status'];
    additionalScreeningStatus = json['additional_screening_status'];
    additionalScreeningDate = json['additional_screening_date'];
    additionalScreeningTime = json['additional_screening_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctorvisitTime = json['doctorvisit_time'];
    isVerified = json['is_verified'];
    screening = json['screening'] != null
        ? Screening.fromJson(json['screening'])
        : null;
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(Employees.fromJson(v));
      });
    }
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
    if (json['online'] != null) {
      online = <Online>[];
      json['online'].forEach((v) {
        online!.add(Online.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userpackage_id'] = userpackageId;
    data['screening_id'] = screeningId;
    data['screening_date'] = screeningDate;
    data['screening_time'] = screeningTime;
    data['labreport_date'] = labreportDate;
    data['doctorvisit_date'] = doctorvisitDate;
    data['doctorreport_date'] = doctorreportDate;
    data['status'] = status;
    data['consultation_type'] = consultationType;
    data['reschedule_status'] = rescheduleStatus;
    data['additional_screening_status'] = additionalScreeningStatus;
    data['additional_screening_date'] = additionalScreeningDate;
    data['additional_screening_time'] = additionalScreeningTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['doctorvisit_time'] = doctorvisitTime;
    data['is_verified'] = isVerified;
    if (screening != null) {
      data['screening'] = screening!.toJson();
    }
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    if (online != null) {
      data['online'] = online!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reports {
  int? id;
  int? memberId;
  int? screeningdateId;
  int? collectedBy;
  int? labId;
  int? verifiedBy;
  String? sampleNo;
  String? sampleDate;
  String? depositedDate;
  String? reportDate;
  String? consultationReportDate;
  String? skipReason;
  String? sampleInfo;
  String? status;
  Nosample? nosample;
  Homeskip? homeskip;
  OnlineConsultation? online;
  Nosample? additionalnosample;
  String? createdAt;
  String? updatedAt;

  Reports(
      {this.id,
      this.memberId,
      this.screeningdateId,
      this.collectedBy,
      this.labId,
      this.verifiedBy,
      this.sampleNo,
      this.sampleDate,
      this.depositedDate,
      this.reportDate,
      this.consultationReportDate,
      this.skipReason,
      this.sampleInfo,
      this.status,
      this.createdAt,
      this.nosample,
      this.homeskip,
      this.online,
      this.additionalnosample,
      this.updatedAt});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    screeningdateId = json['screeningdate_id'];
    collectedBy = json['collected_by'];
    labId = json['lab_id'];
    verifiedBy = json['verified_by'];
    sampleNo = json['sample_no'];
    sampleDate = json['sample_date'];
    depositedDate = json['deposited_date'];
    reportDate = json['report_date'];
    consultationReportDate = json['consultation_report_date'];
    skipReason = json['skip_reason'];
    online = json['online'] != null
        ? OnlineConsultation.fromJson(json['online'])
        : null;
    sampleInfo = json['sample_info'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    homeskip =
        json['homeskip'] != null ? Homeskip.fromJson(json['homeskip']) : null;
    nosample =
        json['nosample'] != null ? Nosample.fromJson(json['nosample']) : null;
    additionalnosample = json['additionalnosample'] != null
        ? Nosample.fromJson(json['additionalnosample'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['screeningdate_id'] = screeningdateId;
    data['collected_by'] = collectedBy;
    data['lab_id'] = labId;
    data['verified_by'] = verifiedBy;
    data['sample_no'] = sampleNo;
    data['sample_date'] = sampleDate;
    data['deposited_date'] = depositedDate;
    data['report_date'] = reportDate;
    data['skip_reason'] = skipReason;
    data['sample_info'] = sampleInfo;
    data['consultation_report_date'] = consultationReportDate;
    data['status'] = status;
    if (nosample != null) {
      data['nosample'] = nosample!.toJson();
    }
    if (online != null) {
      data['online'] = online!.toJson();
    }
    if (homeskip != null) {
      data['homeskip'] = homeskip!.toJson();
    }
    if (additionalnosample != null) {
      data['additionalnosample'] = additionalnosample!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OnlineConsultation {
  int? id;
  int? medicalreportId;
  int? memberId;
  String? startTime;
  String? joinUrl;
  String? startUrl;
  int? meetingId;
  String? meetingPassword;
  int? status;
  String? reason;
  String? createdAt;
  String? updatedAt;
  int? doctorId;
  DoctorSab? doctor;

  OnlineConsultation(
      {this.id,
      this.medicalreportId,
      this.memberId,
      this.startTime,
      this.joinUrl,
      this.startUrl,
      this.meetingId,
      this.meetingPassword,
      this.status,
      this.reason,
      this.createdAt,
      this.updatedAt,
      this.doctorId,
      this.doctor});

  OnlineConsultation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medicalreportId = json['medicalreport_id'];
    memberId = json['member_id'];
    startTime = json['start_time'];
    joinUrl = json['join_url'];
    startUrl = json['start_url'];
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
    status = json['status'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctorId = json['doctor_id'];
    doctor = json['doctor'] != null ? DoctorSab.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['medicalreport_id'] = medicalreportId;
    data['member_id'] = memberId;
    data['start_time'] = startTime;
    data['join_url'] = joinUrl;
    data['start_url'] = startUrl;
    data['meeting_id'] = meetingId;
    data['meeting_password'] = meetingPassword;
    data['status'] = status;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['doctor_id'] = doctorId;
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}

class DoctorSab {
  int? id;
  String? employeeCode;
  String? slug;
  String? gdId;
  int? employeeId;
  int? headEmployeeId;
  String? gender;
  String? address;
  String? nmcNo;
  String? nncNo;
  int? department;
  int? subRoleId;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? specialization;
  String? hospital;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  int? isUser;
  int? status;
  int? percentage;
  String? createdAt;
  String? updatedAt;
  User? user;

  DoctorSab(
      {this.id,
      this.employeeCode,
      this.slug,
      this.gdId,
      this.employeeId,
      this.headEmployeeId,
      this.gender,
      this.address,
      this.nmcNo,
      this.nncNo,
      this.department,
      this.subRoleId,
      this.salutation,
      this.qualification,
      this.yearPracticed,
      this.specialization,
      this.hospital,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.isUser,
      this.status,
      this.percentage,
      this.createdAt,
      this.updatedAt,
      this.user});

  DoctorSab.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeCode = json['employee_code'];
    slug = json['slug'];
    gdId = json['gd_id'];
    employeeId = json['employee_id'];
    headEmployeeId = json['head_employee_id'];
    gender = json['gender'];
    address = json['address'];
    nmcNo = json['nmc_no'];
    nncNo = json['nnc_no'];
    department = json['department'];
    subRoleId = json['sub_role_id'];
    salutation = json['salutation'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    specialization = json['specialization'];
    hospital = json['hospital'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    isUser = json['is_user'];
    status = json['status'];
    percentage = json['percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_code'] = employeeCode;
    data['slug'] = slug;
    data['gd_id'] = gdId;
    data['employee_id'] = employeeId;
    data['head_employee_id'] = headEmployeeId;
    data['gender'] = gender;
    data['address'] = address;
    data['nmc_no'] = nmcNo;
    data['nnc_no'] = nncNo;
    data['department'] = department;
    data['sub_role_id'] = subRoleId;
    data['salutation'] = salutation;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['specialization'] = specialization;
    data['hospital'] = hospital;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['is_user'] = isUser;
    data['status'] = status;
    data['percentage'] = percentage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Homeskip {
  int? id;
  int? employeeId;
  int? familynameId;
  int? screeningdateId;
  int? medicalreportId;
  String? reason;
  String? createdAt;
  String? updatedAt;
  Employee? employee;
  Homeskip(
      {this.id,
      this.employeeId,
      this.familynameId,
      this.screeningdateId,
      this.medicalreportId,
      this.reason,
      this.createdAt,
      this.employee,
      this.updatedAt});

  Homeskip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    familynameId = json['familyname_id'];
    screeningdateId = json['screeningdate_id'];
    medicalreportId = json['medicalreport_id'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['familyname_id'] = familynameId;
    data['screeningdate_id'] = screeningdateId;
    data['medicalreport_id'] = medicalreportId;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}

class Nosample {
  int? id;
  int? employeeId;
  int? familynameId;
  int? screeningdateId;
  int? medicalreportId;
  String? reason;
  int? additionalCollectionStatus;
  String? createdAt;
  String? updatedAt;

  Nosample(
      {this.id,
      this.employeeId,
      this.familynameId,
      this.screeningdateId,
      this.medicalreportId,
      this.reason,
      this.additionalCollectionStatus,
      this.createdAt,
      this.updatedAt});

  Nosample.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    familynameId = json['familyname_id'];
    screeningdateId = json['screeningdate_id'];
    medicalreportId = json['medicalreport_id'];
    reason = json['reason'];
    additionalCollectionStatus = json['additional_collection_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['familyname_id'] = familynameId;
    data['screeningdate_id'] = screeningdateId;
    data['medicalreport_id'] = medicalreportId;
    data['reason'] = reason;
    data['additional_collection_status'] = additionalCollectionStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Online {
  int? id;
  int? screeningdateId;
  int? memberId;
  String? startTime;
  String? joinUrl;
  String? startUrl;
  int? meetingId;
  String? meetingPassword;
  int? status;
  String? createdAt;
  String? updatedAt;

  Online(
      {this.id,
      this.screeningdateId,
      this.memberId,
      this.startTime,
      this.joinUrl,
      this.startUrl,
      this.meetingId,
      this.meetingPassword,
      this.status,
      this.createdAt,
      this.updatedAt});

  Online.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screeningdateId = json['screeningdate_id'];
    memberId = json['member_id'];
    startTime = json['start_time'];
    joinUrl = json['join_url'];
    startUrl = json['start_url'];
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screeningdate_id'] = screeningdateId;
    data['member_id'] = memberId;
    data['start_time'] = startTime;
    data['join_url'] = joinUrl;
    data['start_url'] = startUrl;
    data['meeting_id'] = meetingId;
    data['meeting_password'] = meetingPassword;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Screening {
  int? id;
  String? screening;
  String? createdAt;
  String? updatedAt;

  Screening({this.id, this.screening, this.createdAt, this.updatedAt});

  Screening.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screening = json['screening'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screening'] = screening;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Employees {
  int? id;
  int? screeningdateId;
  int? employeeId;
  String? type;
  String? createdAt;
  String? updatedAt;
  Employee? employee;

  Employees(
      {this.id,
      this.screeningdateId,
      this.employeeId,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.employee});

  Employees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    screeningdateId = json['screeningdate_id'];
    employeeId = json['employee_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['screeningdate_id'] = screeningdateId;
    data['employee_id'] = employeeId;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    return data;
  }
}

class Employee {
  int? id;
  String? employeeCode;
  String? slug;
  int? employeeId;
  int? headEmployeeId;
  String? gender;
  String? address;
  String? nmcNo;
  String? nncNo;
  int? department;
  int? subRoleId;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? specialization;
  String? hospital;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  User? user;

  Employee(
      {this.id,
      this.employeeCode,
      this.slug,
      this.employeeId,
      this.headEmployeeId,
      this.gender,
      this.address,
      this.nmcNo,
      this.nncNo,
      this.department,
      this.subRoleId,
      this.salutation,
      this.qualification,
      this.yearPracticed,
      this.specialization,
      this.hospital,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.createdAt,
      this.updatedAt,
      this.user});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeCode = json['employee_code'];
    slug = json['slug'];
    employeeId = json['employee_id'];
    headEmployeeId = json['head_employee_id'];
    gender = json['gender'];
    address = json['address'];
    nmcNo = json['nmc_no'];
    nncNo = json['nnc_no'];
    department = json['department'];
    subRoleId = json['sub_role_id'];
    salutation = json['salutation'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    specialization = json['specialization'];
    hospital = json['hospital'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_code'] = employeeCode;
    data['slug'] = slug;
    data['employee_id'] = employeeId;
    data['head_employee_id'] = headEmployeeId;
    data['gender'] = gender;
    data['address'] = address;
    data['nmc_no'] = nmcNo;
    data['nnc_no'] = nncNo;
    data['department'] = department;
    data['sub_role_id'] = subRoleId;
    data['salutation'] = salutation;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['specialization'] = specialization;
    data['hospital'] = hospital;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  int? globalFormId;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  int? subrole;
  String? referralLink;

  User(
      {this.id,
      this.globalFormId,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.createdAt,
      this.updatedAt,
      this.subrole,
      this.referralLink});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subrole = json['subrole'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['name'] = name;
    data['phone'] = phone;
    data['role'] = role;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['subrole'] = subrole;
    data['referral_link'] = referralLink;
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
  num? amount;
  int? graceDays;
  int? prepayStatus;
  int? prepayDays;
  String? createdAt;
  String? updatedAt;

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
      this.updatedAt});

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
    return data;
  }
}
