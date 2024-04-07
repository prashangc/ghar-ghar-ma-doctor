class DoctorAppointmentListModel {
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
  DoctorProfile? doctorProfile;
  Meeting? meeting;

  DoctorAppointmentListModel(
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
      this.doctorProfile,
      this.meeting});

  DoctorAppointmentListModel.fromJson(Map<String, dynamic> json) {
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
    doctorProfile = json['doctor_profile'] != null
        ? DoctorProfile.fromJson(json['doctor_profile'])
        : null;
    meeting =
        json['meeting'] != null ? Meeting.fromJson(json['meeting']) : null;
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
    if (doctorProfile != null) {
      data['doctor_profile'] = doctorProfile!.toJson();
    }
    data['meeting'] = meeting;
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
    data['slot'] = slot;
    data['hospital'] = hospital;
    data['service_type'] = serviceType;
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
  Doctor? doctor;

  Bookings(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.doctorId,
      this.createdAt,
      this.updatedAt,
      this.doctor});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    doctorId = json['doctor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
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
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}

class Doctor {
  int? id;
  String? slug;
  int? doctorId;
  String? nmcNo;
  String? gender;
  int? department;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? address;
  String? specialization;
  int? fee;
  List<String>? hospital;
  num? averageRating;
  int? averageReview;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  User? user;

  Doctor(
      {this.id,
      this.slug,
      this.doctorId,
      this.nmcNo,
      this.gender,
      this.department,
      this.salutation,
      this.qualification,
      this.yearPracticed,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.address,
      this.specialization,
      this.fee,
      this.hospital,
      this.averageRating,
      this.averageReview,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.user});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    doctorId = json['doctor_id'];
    nmcNo = json['nmc_no'];
    gender = json['gender'];
    department = json['department'];
    salutation = json['salutation'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    specialization = json['specialization'];
    fee = json['fee'];

    averageRating = json['averageRating'];
    averageReview = json['averageReview'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['doctor_id'] = doctorId;
    data['nmc_no'] = nmcNo;
    data['gender'] = gender;
    data['department'] = department;
    data['salutation'] = salutation;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['address'] = address;
    data['specialization'] = specialization;
    data['fee'] = fee;
    data['hospital'] = hospital;
    data['averageRating'] = averageRating;
    data['averageReview'] = averageReview;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
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

class DoctorProfile {
  int? id;
  String? slug;
  int? doctorId;
  String? nmcNo;
  String? gender;
  int? department;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? address;
  String? specialization;
  int? fee;
  List<String>? hospital;
  num? averageRating;
  int? averageReview;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  DoctorProfile(
      {this.id,
      this.slug,
      this.doctorId,
      this.nmcNo,
      this.gender,
      this.department,
      this.salutation,
      this.qualification,
      this.yearPracticed,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.address,
      this.specialization,
      this.fee,
      this.hospital,
      this.averageRating,
      this.averageReview,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  DoctorProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    doctorId = json['doctor_id'];
    nmcNo = json['nmc_no'];
    gender = json['gender'];
    department = json['department'];
    salutation = json['salutation'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    specialization = json['specialization'];
    fee = json['fee'];
    hospital = json['hospital'] == null
        ? []
        : List<String>.from(json["hospital"].map((x) => x));

    averageRating = json['averageRating'];
    averageReview = json['averageReview'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['doctor_id'] = doctorId;
    data['nmc_no'] = nmcNo;
    data['gender'] = gender;
    data['department'] = department;
    data['salutation'] = salutation;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['address'] = address;
    data['specialization'] = specialization;
    data['fee'] = fee;
    data['hospital'] = hospital;
    data['averageRating'] = averageRating;
    data['averageReview'] = averageReview;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Meeting {
  int? id;
  String? topic;
  String? startTime;
  String? agenda;
  int? bookingId;
  String? joinUrl;
  String? startUrl;
  int? meetingId;
  String? meetingPassword;
  int? status;
  String? createdAt;
  String? updatedAt;

  Meeting(
      {this.id,
      this.topic,
      this.startTime,
      this.agenda,
      this.bookingId,
      this.joinUrl,
      this.startUrl,
      this.meetingId,
      this.meetingPassword,
      this.status,
      this.createdAt,
      this.updatedAt});

  Meeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    startTime = json['start_time'];
    agenda = json['agenda'];
    bookingId = json['booking_id'];
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
    data['topic'] = topic;
    data['start_time'] = startTime;
    data['agenda'] = agenda;
    data['booking_id'] = bookingId;
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
