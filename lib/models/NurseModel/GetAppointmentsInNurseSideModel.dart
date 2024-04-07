class GetAppointmentsInNurseSideModel {
  int? id;
  String? slug;
  int? memberId;
  int? nurseshiftId;
  String? messages;
  String? bookingStatus;
  int? status;
  String? paymentMethod;
  String? paymentDate;
  String? createdAt;
  String? updatedAt;
  Member? member;
  Shift? shift;
  List<NurseSideReports>? reports;

  GetAppointmentsInNurseSideModel(
      {this.id,
      this.slug,
      this.memberId,
      this.nurseshiftId,
      this.messages,
      this.bookingStatus,
      this.status,
      this.paymentMethod,
      this.paymentDate,
      this.createdAt,
      this.updatedAt,
      this.member,
      this.shift,
      this.reports});

  GetAppointmentsInNurseSideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    memberId = json['member_id'];
    nurseshiftId = json['nurseshift_id'];
    messages = json['messages'];
    bookingStatus = json['booking_status'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    shift = json['shift'] != null ? Shift.fromJson(json['shift']) : null;
    if (json['reports'] != null) {
      reports = <NurseSideReports>[];
      json['reports'].forEach((v) {
        reports!.add(NurseSideReports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['member_id'] = memberId;
    data['nurseshift_id'] = nurseshiftId;
    data['messages'] = messages;
    data['booking_status'] = bookingStatus;
    data['status'] = status;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (shift != null) {
      data['shift'] = shift!.toJson();
    }
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Member {
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
  String? familyName;
  String? bp;
  String? bpUpdatedDate;
  String? heartRate;
  String? stepsCount;
  String? createdAt;
  String? updatedAt;
  User? user;

  Member(
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
      this.familyName,
      this.bp,
      this.bpUpdatedDate,
      this.heartRate,
      this.stepsCount,
      this.createdAt,
      this.updatedAt,
      this.user});

  Member.fromJson(Map<String, dynamic> json) {
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
    familyName = json['family_name'];
    bp = json['bp'];
    bpUpdatedDate = json['bp_updated_date'];
    heartRate = json['heart_rate'];
    stepsCount = json['steps_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    data['family_name'] = familyName;
    data['bp'] = bp;
    data['bp_updated_date'] = bpUpdatedDate;
    data['heart_rate'] = heartRate;
    data['steps_count'] = stepsCount;
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
  int? kycId;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  String? subrole;
  String? referralLink;

  User(
      {this.id,
      this.kycId,
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
    kycId = json['kyc_id'];
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
    data['kyc_id'] = kycId;
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

class Shift {
  int? id;
  int? nurseId;
  String? shift;
  String? createdAt;
  String? updatedAt;
  String? date;

  Shift(
      {this.id,
      this.nurseId,
      this.shift,
      this.createdAt,
      this.updatedAt,
      this.date});

  Shift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nurseId = json['nurse_id'];
    shift = json['shift'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nurse_id'] = nurseId;
    data['shift'] = shift;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['date'] = date;
    return data;
  }
}

class NurseSideReports {
  int? id;
  int? bookingId;
  String? date;
  String? time;
  int? pulseRate;
  int? respiratoryRate;
  double? temperature;
  String? bp;
  String? description;
  String? createdAt;
  String? updatedAt;

  NurseSideReports(
      {this.id,
      this.bookingId,
      this.date,
      this.time,
      this.pulseRate,
      this.respiratoryRate,
      this.temperature,
      this.bp,
      this.description,
      this.createdAt,
      this.updatedAt});

  NurseSideReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    date = json['date'];
    time = json['time'];
    pulseRate = json['pulse_rate'];
    respiratoryRate = json['respiratory_rate'];
    temperature = json['temperature'];
    bp = json['bp'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['date'] = date;
    data['time'] = time;
    data['pulse_rate'] = pulseRate;
    data['respiratory_rate'] = respiratoryRate;
    data['temperature'] = temperature;
    data['bp'] = bp;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
