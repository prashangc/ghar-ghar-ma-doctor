class ExternalMedicalDetailsModel {
  int? id;
  int? memberId;
  int? doctorId;
  String? checkDate;
  String? hospital;
  String? doctorName;
  String? doctorNmc;
  String? observation;
  String? finding;
  String? medication;
  String? rejectReason;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? doctorRejectReason;
  int? departmentId;
  String? isOther;
  List<MedicalReport>? medicalReport;
  Doctor? doctor;
  Department? department;

  ExternalMedicalDetailsModel(
      {this.id,
      this.memberId,
      this.doctorId,
      this.checkDate,
      this.hospital,
      this.doctorName,
      this.doctorNmc,
      this.observation,
      this.finding,
      this.medication,
      this.rejectReason,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.doctorRejectReason,
      this.departmentId,
      this.isOther,
      this.medicalReport,
      this.doctor,
      this.department});

  ExternalMedicalDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    doctorId = json['doctor_id'];
    checkDate = json['check_date'];
    hospital = json['hospital'];
    doctorName = json['doctor_name'];
    doctorNmc = json['doctor_nmc'];
    observation = json['observation'];
    finding = json['finding'];
    medication = json['medication'];
    rejectReason = json['reject_reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctorRejectReason = json['doctor_reject_reason'];
    departmentId = json['department_id'];
    isOther = json['is_other'];
    if (json['medical_report'] != null) {
      medicalReport = <MedicalReport>[];
      json['medical_report'].forEach((v) {
        medicalReport!.add(MedicalReport.fromJson(v));
      });
    }
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['doctor_id'] = doctorId;
    data['check_date'] = checkDate;
    data['hospital'] = hospital;
    data['doctor_name'] = doctorName;
    data['doctor_nmc'] = doctorNmc;
    data['observation'] = observation;
    data['finding'] = finding;
    data['medication'] = medication;
    data['reject_reason'] = rejectReason;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['doctor_reject_reason'] = doctorRejectReason;
    data['department_id'] = departmentId;
    data['is_other'] = isOther;
    if (medicalReport != null) {
      data['medical_report'] = medicalReport!.map((v) => v.toJson()).toList();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    if (department != null) {
      data['department'] = department!.toJson();
    }
    return data;
  }
}

class MedicalReport {
  int? id;
  int? memberId;
  String? report;
  String? reportPath;
  String? createdAt;
  String? updatedAt;
  int? uploadMedicalHistoryConsultationId;

  MedicalReport(
      {this.id,
      this.memberId,
      this.report,
      this.reportPath,
      this.createdAt,
      this.updatedAt,
      this.uploadMedicalHistoryConsultationId});

  MedicalReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    report = json['report'];
    reportPath = json['report_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uploadMedicalHistoryConsultationId =
        json['upload_medical_history_consultation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['report'] = report;
    data['report_path'] = reportPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['upload_medical_history_consultation_id'] =
        uploadMedicalHistoryConsultationId;
    return data;
  }
}

class Doctor {
  int? id;
  String? employeeCode;
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
  List<String>? hospital;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  int? status;
  int? percentage;
  String? createdAt;
  String? updatedAt;
  UserExternal? user;

  Doctor(
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
      this.status,
      this.percentage,
      this.createdAt,
      this.updatedAt,
      this.user});

  Doctor.fromJson(Map<String, dynamic> json) {
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
    hospital = json['hospital'] == null
        ? []
        : List<String>.from(json["hospital"].map((x) => x));
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    status = json['status'];
    percentage = json['percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserExternal.fromJson(json['user']) : null;
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

class UserExternal {
  int? id;
  int? globalFormId;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? name;
  String? phone;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  int? isEnabled;
  int? phoneVerified;
  int? subrole;
  int? isSchool;
  String? createdAt;
  String? updatedAt;
  String? referralLink;

  UserExternal(
      {this.id,
      this.globalFormId,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.name,
      this.phone,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.isEnabled,
      this.phoneVerified,
      this.subrole,
      this.isSchool,
      this.createdAt,
      this.updatedAt,
      this.referralLink});

  UserExternal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    name = json['name'];
    phone = json['phone'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    isEnabled = json['is_enabled'];
    phoneVerified = json['phone_verified'];
    subrole = json['subrole'];
    isSchool = json['is_school'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['user_name'] = userName;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['phone'] = phone;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['is_enabled'] = isEnabled;
    data['phone_verified'] = phoneVerified;
    data['subrole'] = subrole;
    data['is_school'] = isSchool;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['referral_link'] = referralLink;
    return data;
  }
}

class Department {
  int? id;
  String? department;
  String? departmentNepali;
  List<String>? symptoms;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  Department(
      {this.id,
      this.department,
      this.departmentNepali,
      this.symptoms,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    departmentNepali = json['department_nepali'];
    symptoms = json['symptoms'].cast<String>();
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
