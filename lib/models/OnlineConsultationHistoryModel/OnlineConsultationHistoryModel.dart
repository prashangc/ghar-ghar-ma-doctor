class OnlineConsultationHistoryModel {
  int? id;
  String? startTime;
  String? agenda;
  int? memberId;
  String? endTime;
  int? doctorId;
  String? history;
  String? examination;
  String? treatment;
  String? progress;
  Memberr? member;
  Doctorr? doctor;

  OnlineConsultationHistoryModel(
      {this.id,
      this.startTime,
      this.agenda,
      this.memberId,
      this.endTime,
      this.doctorId,
      this.history,
      this.examination,
      this.treatment,
      this.progress,
      this.member,
      this.doctor});

  OnlineConsultationHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    agenda = json['agenda'];
    memberId = json['member_id'];
    endTime = json['end_time'];
    doctorId = json['doctor_id'];
    history = json['history'];
    examination = json['examination'];
    treatment = json['treatment'];
    progress = json['progress'];
    member = json['member'] != null ? Memberr.fromJson(json['member']) : null;
    doctor = json['doctor'] != null ? Doctorr.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['agenda'] = agenda;
    data['member_id'] = memberId;
    data['end_time'] = endTime;
    data['doctor_id'] = doctorId;
    data['history'] = history;
    data['examination'] = examination;
    data['treatment'] = treatment;
    data['progress'] = progress;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}

class Memberr {
  int? id;
  int? memberId;
  String? gdId;
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
  String? createdAt;
  String? updatedAt;
  UserConsultation? user;

  Memberr(
      {this.id,
      this.memberId,
      this.gdId,
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
      this.createdAt,
      this.updatedAt,
      this.user});

  Memberr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    gdId = json['gd_id'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user =
        json['user'] != null ? UserConsultation.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['gd_id'] = gdId;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserConsultation {
  int? id;
  String? name;
  String? referralLink;

  UserConsultation({this.id, this.name, this.referralLink});

  UserConsultation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['referral_link'] = referralLink;
    return data;
  }
}

class Doctorr {
  int? id;
  int? employeeCode;
  String? slug;
  String? gdId;
  int? employeeId;
  int? headEmployeeId;
  String? gender;
  String? address;
  String? nmcNo;
  int? nncNo;
  int? department;
  int? subRoleId;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? specialization;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  int? status;
  String? createdAt;
  String? updatedAt;
  UserConsultation? user;

  Doctorr(
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
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.user});

  Doctorr.fromJson(Map<String, dynamic> json) {
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
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user =
        json['user'] != null ? UserConsultation.fromJson(json['user']) : null;
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
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
