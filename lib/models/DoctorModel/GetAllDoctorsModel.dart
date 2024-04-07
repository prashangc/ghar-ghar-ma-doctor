class AllDoctorsModel {
  int? currentPage;
  List<Doctors>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AllDoctorsModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  AllDoctorsModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Doctors>[];
      json['data'].forEach((v) {
        data!.add(Doctors.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Doctors {
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
  String? latitude;
  String? longitude;
  num? averageRating;
  int? averageReview;
  String? createdAt;
  String? updatedAt;
  Departments? departments;
  List<Bookings>? bookings;
  User? user;

  Doctors(
      {this.id,
      this.slug,
      this.doctorId,
      this.nmcNo,
      this.gender,
      this.department,
      // this.doctorType,
      // this.doctorServiceType,
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
      this.bookings,
      this.departments,
      this.user});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    doctorId = json['doctor_id'];
    nmcNo = json['nmc_no'];
    gender = json['gender'];
    department = json['department'];
    salutation = json['salutation'];
    // doctorType = json['doctor_type'];
    // doctorServiceType = json['doctor_service_type'];

    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    averageRating = json['averageRating'];
    averageReview = json['averageReview'];
    specialization = json['specialization'];
    fee = json['fee'];
    hospital = json['hospital'] == null
        ? []
        : List<String>.from(json["hospital"].map((x) => x));
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
    }
    departments = json['departments'] != null
        ? Departments.fromJson(json['departments'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['doctor_id'] = doctorId;
    data['nmc_no'] = nmcNo;
    data['gender'] = gender;
    // data['doctor_type'] = doctorType;
    // data['doctor_service_type'] = doctorServiceType;
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
    data['averageRating'] = averageRating;
    data['averageReview'] = averageReview;
    data['fee'] = fee;
    data['hospital'] = hospital;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    if (departments != null) {
      data['departments'] = departments!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
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
  List<Slots>? slots;

  Bookings(
      {this.id,
      this.date,
      this.startTime,
      this.endTime,
      this.doctorId,
      this.createdAt,
      this.updatedAt,
      this.slots});

  Bookings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    doctorId = json['doctor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(Slots.fromJson(v));
      });
    }
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
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  int? id;
  int? slotId;
  String? expiryDate;
  String? slot;
  int? hospital;
  String? serviceType;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  // Null? appointments;

  Slots({
    this.id,
    this.slotId,
    this.expiryDate,
    this.slot,
    this.hospital,
    this.serviceType,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    // this.appointments
  });
  Slots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slotId = json['slot_id'];
    expiryDate = json['expiry_date'];
    slot = json['slot'];
    hospital = json['hospital'];
    serviceType = json['service_type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // appointments = json['appointments'];
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
    // data['appointments'] = this.appointments;
    return data;
  }
}

class Departments {
  int? id;
  String? department;

  String? departmentNepali;
  List<String>? symptoms;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  Departments(
      {this.id,
      this.department,
      this.departmentNepali,
      this.symptoms,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];

    departmentNepali = json['department_nepali'];
    symptoms = json['symptoms'] == null
        ? []
        : List<String>.from(json["symptoms"].map((x) => x));

    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department'] = department;

    data['department_nepali'] = departmentNepali;
    data['symptoms'] = symptoms;
    data['image'] = image;
    data['image_path'] = imagePath;
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

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
