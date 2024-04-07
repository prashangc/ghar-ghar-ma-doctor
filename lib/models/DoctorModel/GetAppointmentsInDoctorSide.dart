class GetAppointmentsInDoctorSide {
  int? id;
  String? slug;
  int? userId;
  int? bookingId;
  int? doctorId;
  String? doctorServiceType;
  String? messages;
  String? bookingStatus;
  int? status;
  String? paymentMethod;
  String? paymentDate;
  String? cancelReason;
  String? createdAt;
  String? updatedAt;
  Slot? slot;
  Member? member;
  DoctorSideReport? report;

  GetAppointmentsInDoctorSide(
      {this.id,
      this.slug,
      this.userId,
      this.bookingId,
      this.doctorId,
      this.doctorServiceType,
      this.messages,
      this.bookingStatus,
      this.status,
      this.paymentMethod,
      this.paymentDate,
      this.cancelReason,
      this.createdAt,
      this.updatedAt,
      this.slot,
      this.member,
      this.report});

  GetAppointmentsInDoctorSide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    doctorId = json['doctor_id'];
    doctorServiceType = json['doctor_service_type'];
    messages = json['messages'];
    bookingStatus = json['booking_status'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    cancelReason = json['cancel_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slot = json['slot'] != null ? Slot.fromJson(json['slot']) : null;
    member = json['member'] != null ? Member.fromJson(json['member']) : null;

    report = json['report'] != null
        ? DoctorSideReport.fromJson(json['report'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['user_id'] = userId;
    data['booking_id'] = bookingId;
    data['doctor_id'] = doctorId;
    data['doctor_service_type'] = doctorServiceType;
    data['messages'] = messages;
    data['booking_status'] = bookingStatus;
    data['status'] = status;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['cancel_reason'] = cancelReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (slot != null) {
      data['slot'] = slot!.toJson();
    }
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (report != null) {
      data['report'] = report!.toJson();
    }
    return data;
  }
}

class Slot {
  int? id;
  int? slotId;
  String? expiryDate;
  String? slot;
  int? hospital;
  String? serviceType;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Bookings? bookings;

  Slot(
      {this.id,
      this.slotId,
      this.expiryDate,
      this.slot,
      this.hospital,
      this.serviceType,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.bookings});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slotId = json['slot_id'];
    expiryDate = json['expiry_date'];
    slot = json['slot'];
    hospital = json['hospital'];
    serviceType = json['service_type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bookings =
        json['bookings'] != null ? Bookings.fromJson(json['bookings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slot_id'] = slotId;
    data['expiry_date'] = expiryDate;
    data['hospital'] = hospital;
    data['service_type'] = serviceType;
    data['slot'] = slot;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (bookings != null) {
      data['bookings'] = bookings!.toJson();
    }
    return data;
  }
}

class Bookings {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  int? doctorId;
  String? createdAt;
  String? updatedAt;

  Bookings(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.doctorId,
      this.createdAt,
      this.updatedAt});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    doctorId = json['doctor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['doctor_id'] = doctorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  int? subrole;
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

class DoctorSideReport {
  int? id;
  int? bookingId;
  String? history;
  String? examination;
  String? treatment;
  String? progress;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  DoctorSideReport(
      {this.id,
      this.bookingId,
      this.history,
      this.examination,
      this.treatment,
      this.progress,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  DoctorSideReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    history = json['history'];
    examination = json['examination'];
    treatment = json['treatment'];
    progress = json['progress'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['history'] = history;
    data['examination'] = examination;
    data['treatment'] = treatment;
    data['progress'] = progress;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
