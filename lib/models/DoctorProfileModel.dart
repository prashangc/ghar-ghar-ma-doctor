class DoctorProfileModel {
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
  num? averageReview;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  User? user;
  Departments? departments;

  DoctorProfileModel(
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
      this.latitude,
      this.longitude,
      this.averageRating,
      this.averageReview,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.departments});

  DoctorProfileModel.fromJson(Map<String, dynamic> json) {
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    departments = json['departments'] != null
        ? Departments.fromJson(json['departments'])
        : null;
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
    data['latitude'] = latitude;
    data['averageRating'] = averageRating;
    data['averageReview'] = averageReview;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (departments != null) {
      data['departments'] = departments!.toJson();
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
