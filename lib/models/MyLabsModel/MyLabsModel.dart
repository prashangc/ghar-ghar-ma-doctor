class MyLabsModel {
  int? id;
  int? memberId;
  int? labtechnicianId;
  int? labprofileId;
  int? labtestId;
  String? date;
  String? time;
  String? bookingStatus;
  int? status;
  String? price;
  String? paymentMethod;
  String? paymentDate;
  String? sampleNo;
  String? sampleDate;
  String? reportDate;
  String? createdAt;
  String? updatedAt;
  Lab? lab;
  Labprofile? labprofile;
  Labtest? labtest;
  List<Reports>? reports;
  MyLabsModel(
      {this.id,
      this.memberId,
      this.labtechnicianId,
      this.labprofileId,
      this.labtestId,
      this.date,
      this.time,
      this.bookingStatus,
      this.status,
      this.price,
      this.paymentMethod,
      this.paymentDate,
      this.sampleNo,
      this.sampleDate,
      this.reportDate,
      this.createdAt,
      this.updatedAt,
      this.lab,
      this.labprofile,
      this.labtest,
      this.reports});

  MyLabsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    labtechnicianId = json['labtechnician_id'];
    labprofileId = json['labprofile_id'];
    labtestId = json['labtest_id'];
    date = json['date'];
    time = json['time'];
    bookingStatus = json['booking_status'];
    status = json['status'];
    price = json['price'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    sampleNo = json['sample_no'];
    sampleDate = json['sample_date'];
    reportDate = json['report_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lab = json['lab'] != null ? Lab.fromJson(json['lab']) : null;
    labprofile = json['labprofile'] != null
        ? Labprofile.fromJson(json['labprofile'])
        : null;
    labtest =
        json['labtest'] != null ? Labtest.fromJson(json['labtest']) : null;
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['labtechnician_id'] = labtechnicianId;
    data['labprofile_id'] = labprofileId;
    data['labtest_id'] = labtestId;
    data['date'] = date;
    data['time'] = time;
    data['booking_status'] = bookingStatus;
    data['status'] = status;
    data['price'] = price;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['sample_no'] = sampleNo;
    data['sample_date'] = sampleDate;
    data['report_date'] = reportDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (lab != null) {
      data['lab'] = lab!.toJson();
    }
    if (labprofile != null) {
      data['labprofile'] = labprofile!.toJson();
    }
    if (labtest != null) {
      data['labtest'] = labtest!.toJson();
    }
    if (reports != null) {
      data['reports'] = reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lab {
  int? id;
  String? slug;
  int? employeeId;
  int? headEmployeeId;
  String? gender;
  String? address;
  int? nmcNo;
  int? nncNo;
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
  Subrole? subrole;
  Lab(
      {this.id,
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
      this.subrole,
      this.user});

  Lab.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    subrole =
        json['subrole'] != null ? Subrole.fromJson(json['subrole']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    if (subrole != null) {
      data['subrole'] = subrole!.toJson();
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

class Subrole {
  int? id;
  int? roleId;
  String? subrole;
  String? percentage;
  String? createdAt;
  String? updatedAt;

  Subrole(
      {this.id,
      this.roleId,
      this.subrole,
      this.percentage,
      this.createdAt,
      this.updatedAt});

  Subrole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    subrole = json['subrole'];
    percentage = json['percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_id'] = roleId;
    data['subrole'] = subrole;
    data['percentage'] = percentage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Labprofile {
  int? id;
  int? departmentId;
  String? profileName;
  String? price;
  String? createdAt;
  String? updatedAt;
  List<Labtest>? labtest;

  Labprofile(
      {this.id,
      this.departmentId,
      this.profileName,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.labtest});

  Labprofile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    profileName = json['profile_name'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['labtest'] != null) {
      labtest = <Labtest>[];
      json['labtest'].forEach((v) {
        labtest!.add(Labtest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department_id'] = departmentId;
    data['profile_name'] = profileName;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (labtest != null) {
      data['labtest'] = labtest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Labtest {
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
  Labdepartment? labdepartment;

  Labtest(
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
      this.updatedAt,
      this.labdepartment});

  Labtest.fromJson(Map<String, dynamic> json) {
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
    labdepartment = json['labdepartment'] != null
        ? Labdepartment.fromJson(json['labdepartment'])
        : null;
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
    if (labdepartment != null) {
      data['labdepartment'] = labdepartment!.toJson();
    }
    return data;
  }
}

class Reports {
  int? id;
  int? bookId;
  int? labtestId;
  int? labvalueId;
  int? minRange;
  int? maxRange;
  int? value;
  String? result;
  String? report;
  String? reportPath;
  String? createdAt;
  String? updatedAt;
  Labvalue? labvalue;
  Labtest? labtest;

  Reports(
      {this.id,
      this.bookId,
      this.labtestId,
      this.labvalueId,
      this.minRange,
      this.maxRange,
      this.value,
      this.result,
      this.report,
      this.reportPath,
      this.createdAt,
      this.updatedAt,
      this.labvalue,
      this.labtest});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    labtestId = json['labtest_id'];
    labvalueId = json['labvalue_id'];
    minRange = json['min_range'];
    maxRange = json['max_range'];
    value = json['value'];
    result = json['result'];
    report = json['report'];
    reportPath = json['report_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    labvalue =
        json['labvalue'] != null ? Labvalue.fromJson(json['labvalue']) : null;
    labtest =
        json['labtest'] != null ? Labtest.fromJson(json['labtest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['book_id'] = bookId;
    data['labtest_id'] = labtestId;
    data['labvalue_id'] = labvalueId;
    data['min_range'] = minRange;
    data['max_range'] = maxRange;
    data['value'] = value;
    data['result'] = result;
    data['report'] = report;
    data['report_path'] = reportPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (labvalue != null) {
      data['labvalue'] = labvalue!.toJson();
    }
    if (labtest != null) {
      data['labtest'] = labtest!.toJson();
    }
    return data;
  }
}

class Labvalue {
  int? id;
  int? labtestId;
  String? resultName;
  String? createdAt;
  String? updatedAt;

  Labvalue(
      {this.id,
      this.labtestId,
      this.resultName,
      this.createdAt,
      this.updatedAt});

  Labvalue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labtestId = json['labtest_id'];
    resultName = json['result_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['labtest_id'] = labtestId;
    data['result_name'] = resultName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Labdepartment {
  int? id;
  String? department;
  String? createdAt;
  String? updatedAt;

  Labdepartment({this.id, this.department, this.createdAt, this.updatedAt});

  Labdepartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department'] = department;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
