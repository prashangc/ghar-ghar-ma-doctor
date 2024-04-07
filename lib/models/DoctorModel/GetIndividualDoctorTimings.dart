class GetIndividualDoctorTimings {
  int? id;
  String? slug;
  int? doctorId;
  String? nmcNo;
  String? gender;
  int? department;
  String? salutation;
  String? doctorType;
  String? doctorServiceType;
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
  int? averageRating;
  int? averageReview;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  List<BookingsDetails>? bookings;
  User? user;

  GetIndividualDoctorTimings(
      {this.id,
      this.slug,
      this.doctorId,
      this.nmcNo,
      this.gender,
      this.department,
      this.salutation,
      this.doctorType,
      this.doctorServiceType,
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
      this.bookings,
      this.user});

  GetIndividualDoctorTimings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    doctorId = json['doctor_id'];
    nmcNo = json['nmc_no'];
    gender = json['gender'];
    department = json['department'];
    salutation = json['salutation'];
    doctorType = json['doctor_type'];
    doctorServiceType = json['doctor_service_type'];
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
    if (json['bookings'] != null) {
      bookings = <BookingsDetails>[];
      json['bookings'].forEach((v) {
        bookings!.add(BookingsDetails.fromJson(v));
      });
    }
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
    data['doctor_type'] = doctorType;
    data['doctor_service_type'] = doctorServiceType;
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
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class BookingsDetails {
  int? id;
  String? date;
  String? startTime;
  String? endTime;
  int? doctorId;
  String? createdAt;
  String? updatedAt;
  List<Times>? times;

  BookingsDetails(
      {this.id,
      this.date,
      this.doctorId,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.updatedAt,
      this.times});

  BookingsDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    doctorId = json['doctor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['times'] != null) {
      times = <Times>[];
      json['times'].forEach((v) {
        times!.add(Times.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['date'] = date;
    data['doctor_id'] = doctorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (times != null) {
      data['times'] = times!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Times {
  int? id;
  int? slotId;
  String? expiryDate;
  String? slot;
  int? hospital;
  String? serviceType;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Times(
      {this.id,
      this.slotId,
      this.expiryDate,
      this.slot,
      this.hospital,
      this.serviceType,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Times.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slotId = json['slot_id'];
    expiryDate = json['expiry_date'];
    slot = json['slot'];
    hospital = json['hospital'];
    serviceType = json['service_type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
