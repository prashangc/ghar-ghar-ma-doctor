class MyMedicalLabReportModel {
  String? message;
  List<LabReportModel>? labReportModel;

  MyMedicalLabReportModel({this.message, this.labReportModel});

  MyMedicalLabReportModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['reports'] != null) {
      labReportModel = <LabReportModel>[];
      json['reports'].forEach((v) {
        labReportModel!.add(LabReportModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (labReportModel != null) {
      data['reports'] = labReportModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabReportModel {
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
  String? status;
  String? createdAt;
  String? updatedAt;
  Screeningdate? screeningdate;
  Collectedby? collectedby;
  Collectedby? lab;
  Collectedby? verifiedby;
  List<Advice>? advice;
  Pdf? pdf;
  List<MyLabreports>? labreports;
  LabReportModel(
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
      this.status,
      this.createdAt,
      this.updatedAt,
      this.screeningdate,
      this.collectedby,
      this.lab,
      this.verifiedby,
      this.advice,
      this.pdf,
      this.labreports});

  LabReportModel.fromJson(Map<String, dynamic> json) {
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
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    screeningdate = json['screeningdate'] != null
        ? Screeningdate.fromJson(json['screeningdate'])
        : null;
    collectedby = json['collectedby'] != null
        ? Collectedby.fromJson(json['collectedby'])
        : null;
    lab = json['lab'] != null ? Collectedby.fromJson(json['lab']) : null;
    verifiedby = json['verifiedby'] != null
        ? Collectedby.fromJson(json['verifiedby'])
        : null;
    if (json['advice'] != null) {
      advice = <Advice>[];
      json['advice'].forEach((v) {
        advice!.add(Advice.fromJson(v));
      });
    }
    pdf = json['pdf'] != null ? Pdf.fromJson(json['pdf']) : null;
    if (json['labreports'] != null) {
      labreports = <MyLabreports>[];
      json['labreports'].forEach((v) {
        labreports!.add(MyLabreports.fromJson(v));
      });
    }
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
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (screeningdate != null) {
      data['screeningdate'] = screeningdate!.toJson();
    }
    if (collectedby != null) {
      data['collectedby'] = collectedby!.toJson();
    }
    if (lab != null) {
      data['lab'] = lab!.toJson();
    }
    if (verifiedby != null) {
      data['verifiedby'] = verifiedby!.toJson();
    }
    if (advice != null) {
      data['advice'] = advice!.map((v) => v.toJson()).toList();
    }
    if (pdf != null) {
      data['pdf'] = pdf!.toJson();
    }
    if (labreports != null) {
      data['labreports'] = labreports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Screeningdate {
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
  String? createdAt;
  String? updatedAt;
  MyScreening? screening;

  Screeningdate(
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
      this.createdAt,
      this.updatedAt,
      this.screening});

  Screeningdate.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    screening = json['screening'] != null
        ? MyScreening.fromJson(json['screening'])
        : null;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (screening != null) {
      data['screening'] = screening!.toJson();
    }
    return data;
  }
}

class MyScreening {
  int? id;
  String? screening;
  String? createdAt;
  String? updatedAt;

  MyScreening({this.id, this.screening, this.createdAt, this.updatedAt});

  MyScreening.fromJson(Map<String, dynamic> json) {
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

class Collectedby {
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
  UserDetailsFor? user;

  Collectedby(
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

  Collectedby.fromJson(Map<String, dynamic> json) {
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
    user = json['user'] != null ? UserDetailsFor.fromJson(json['user']) : null;
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

class UserDetailsFor {
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

  UserDetailsFor(
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

  UserDetailsFor.fromJson(Map<String, dynamic> json) {
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

class Pdf {
  int? id;
  int? reportId;
  String? report;
  String? reportPath;
  String? createdAt;
  String? updatedAt;

  Pdf(
      {this.id,
      this.reportId,
      this.report,
      this.reportPath,
      this.createdAt,
      this.updatedAt});

  Pdf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportId = json['report_id'];
    report = json['report'];
    reportPath = json['report_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['report_id'] = reportId;
    data['report'] = report;
    data['report_path'] = reportPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ThisUser {
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

  ThisUser(
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

  ThisUser.fromJson(Map<String, dynamic> json) {
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

class Advice {
  int? id;
  int? packageScreeningTeamsId;
  int? reportId;
  String? feedback;
  String? file;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  Team? team;

  Advice(
      {this.id,
      this.packageScreeningTeamsId,
      this.reportId,
      this.feedback,
      this.file,
      this.filePath,
      this.createdAt,
      this.updatedAt,
      this.team});

  Advice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageScreeningTeamsId = json['package_screening_teams_id'];
    reportId = json['report_id'];
    feedback = json['feedback'];
    file = json['file'];
    filePath = json['file_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_screening_teams_id'] = packageScreeningTeamsId;
    data['report_id'] = reportId;
    data['feedback'] = feedback;
    data['file'] = file;
    data['file_path'] = filePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (team != null) {
      data['team'] = team!.toJson();
    }
    return data;
  }
}

class Team {
  int? id;
  int? screeningdateId;
  int? employeeId;
  String? type;
  String? createdAt;
  String? updatedAt;
  Employee? employee;

  Team(
      {this.id,
      this.screeningdateId,
      this.employeeId,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.employee});

  Team.fromJson(Map<String, dynamic> json) {
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
  int? employeeCode;
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
  int? hospital;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  ThisUser? user;

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
    user = json['user'] != null ? ThisUser.fromJson(json['user']) : null;
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

class MyLabreports {
  int? id;
  int? reportId;
  int? testId;
  int? labvalueId;
  num? minRange;
  num? maxRange;
  num? amberMinRange;
  num? amberMaxRange;
  num? redMinRange;
  num? redMaxRange;
  num? value;
  String? result;
  String? report;
  String? reportPath;
  String? createdAt;
  String? updatedAt;
  LabtestModelData? labtest;

  MyLabreports(
      {this.id,
      this.reportId,
      this.testId,
      this.labvalueId,
      this.minRange,
      this.maxRange,
      this.amberMinRange,
      this.amberMaxRange,
      this.redMinRange,
      this.redMaxRange,
      this.value,
      this.result,
      this.report,
      this.reportPath,
      this.createdAt,
      this.updatedAt,
      this.labtest});

  MyLabreports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportId = json['report_id'];
    testId = json['test_id'];
    labvalueId = json['labvalue_id'];
    minRange = json['min_range'];
    maxRange = json['max_range'];
    amberMinRange = json['amber_min_range'];
    amberMaxRange = json['amber_max_range'];
    redMinRange = json['red_min_range'];
    redMaxRange = json['red_max_range'];
    value = json['value'];
    result = json['result'];
    report = json['report'];
    reportPath = json['report_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    labtest = json['labtest'] != null
        ? LabtestModelData.fromJson(json['labtest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['report_id'] = reportId;
    data['test_id'] = testId;
    data['labvalue_id'] = labvalueId;
    data['min_range'] = minRange;
    data['max_range'] = maxRange;
    data['amber_min_range'] = amberMinRange;
    data['amber_max_range'] = amberMaxRange;
    data['red_min_range'] = redMinRange;
    data['red_max_range'] = redMaxRange;
    data['value'] = value;
    data['result'] = result;
    data['report'] = report;
    data['report_path'] = reportPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (labtest != null) {
      data['labtest'] = labtest!.toJson();
    }
    return data;
  }
}

class LabtestModelData {
  int? id;
  int? departmentId;
  int? profileId;
  String? code;
  String? tests;
  int? maleMinRange;
  int? maleMaxRange;
  int? femaleMinRange;
  int? femaleMaxRange;
  int? childMinRange;
  int? childMaxRange;
  int? maleAmberMinRange;
  int? maleAmberMaxRange;
  int? femaleAmberMinRange;
  int? femaleAmberMaxRange;
  int? childAmberMinRange;
  int? childAmberMaxRange;
  int? maleRedMinRange;
  int? maleRedMaxRange;
  int? femaleRedMinRange;
  int? femaleRedMaxRange;
  int? childRedMinRange;
  int? childRedMaxRange;
  String? testResultType;
  String? unit;
  String? price;
  String? createdAt;
  String? updatedAt;

  LabtestModelData(
      {this.id,
      this.departmentId,
      this.profileId,
      this.code,
      this.tests,
      this.maleMinRange,
      this.maleMaxRange,
      this.femaleMinRange,
      this.femaleMaxRange,
      this.childMinRange,
      this.childMaxRange,
      this.maleAmberMinRange,
      this.maleAmberMaxRange,
      this.femaleAmberMinRange,
      this.femaleAmberMaxRange,
      this.childAmberMinRange,
      this.childAmberMaxRange,
      this.maleRedMinRange,
      this.maleRedMaxRange,
      this.femaleRedMinRange,
      this.femaleRedMaxRange,
      this.childRedMinRange,
      this.childRedMaxRange,
      this.testResultType,
      this.unit,
      this.price,
      this.createdAt,
      this.updatedAt});

  LabtestModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    profileId = json['profile_id'];
    code = json['code'];
    tests = json['tests'];
    maleMinRange = json['male_min_range'];
    maleMaxRange = json['male_max_range'];
    femaleMinRange = json['female_min_range'];
    femaleMaxRange = json['female_max_range'];
    childMinRange = json['child_min_range'];
    childMaxRange = json['child_max_range'];
    maleAmberMinRange = json['male_amber_min_range'];
    maleAmberMaxRange = json['male_amber_max_range'];
    femaleAmberMinRange = json['female_amber_min_range'];
    femaleAmberMaxRange = json['female_amber_max_range'];
    childAmberMinRange = json['child_amber_min_range'];
    childAmberMaxRange = json['child_amber_max_range'];
    maleRedMinRange = json['male_red_min_range'];
    maleRedMaxRange = json['male_red_max_range'];
    femaleRedMinRange = json['female_red_min_range'];
    femaleRedMaxRange = json['female_red_max_range'];
    childRedMinRange = json['child_red_min_range'];
    childRedMaxRange = json['child_red_max_range'];
    testResultType = json['test_result_type'];
    unit = json['unit'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department_id'] = departmentId;
    data['profile_id'] = profileId;
    data['code'] = code;
    data['tests'] = tests;
    data['male_min_range'] = maleMinRange;
    data['male_max_range'] = maleMaxRange;
    data['female_min_range'] = femaleMinRange;
    data['female_max_range'] = femaleMaxRange;
    data['child_min_range'] = childMinRange;
    data['child_max_range'] = childMaxRange;
    data['male_amber_min_range'] = maleAmberMinRange;
    data['male_amber_max_range'] = maleAmberMaxRange;
    data['female_amber_min_range'] = femaleAmberMinRange;
    data['female_amber_max_range'] = femaleAmberMaxRange;
    data['child_amber_min_range'] = childAmberMinRange;
    data['child_amber_max_range'] = childAmberMaxRange;
    data['male_red_min_range'] = maleRedMinRange;
    data['male_red_max_range'] = maleRedMaxRange;
    data['female_red_min_range'] = femaleRedMinRange;
    data['female_red_max_range'] = femaleRedMaxRange;
    data['child_red_min_range'] = childRedMinRange;
    data['child_red_max_range'] = childRedMaxRange;
    data['test_result_type'] = testResultType;
    data['unit'] = unit;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
