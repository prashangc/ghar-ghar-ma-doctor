class GetAllLabServicesModel {
  List<Labprofiles>? labprofiles;
  List<Labtests>? labtests;

  GetAllLabServicesModel({this.labprofiles, this.labtests});

  GetAllLabServicesModel.fromJson(Map<String, dynamic> json) {
    if (json['labprofiles'] != null) {
      labprofiles = <Labprofiles>[];
      json['labprofiles'].forEach((v) {
        labprofiles!.add(Labprofiles.fromJson(v));
      });
    }
    if (json['labtests'] != null) {
      labtests = <Labtests>[];
      json['labtests'].forEach((v) {
        labtests!.add(Labtests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (labprofiles != null) {
      data['labprofiles'] = labprofiles!.map((v) => v.toJson()).toList();
    }
    if (labtests != null) {
      data['labtests'] = labtests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Labprofiles {
  int? id;
  int? departmentId;
  String? profileName;
  String? price;
  String? createdAt;
  String? updatedAt;
  List<Labtest>? labtest;

  Labprofiles(
      {this.id,
      this.departmentId,
      this.profileName,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.labtest});

  Labprofiles.fromJson(Map<String, dynamic> json) {
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
      this.updatedAt});

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

class Labtests {
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
  Labprofile? labprofile;

  Labtests(
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
      this.labdepartment,
      this.labprofile});

  Labtests.fromJson(Map<String, dynamic> json) {
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
    labprofile = json['labprofile'] != null
        ? Labprofile.fromJson(json['labprofile'])
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
    if (labprofile != null) {
      data['labprofile'] = labprofile!.toJson();
    }
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

class Labprofile {
  int? id;
  int? departmentId;
  String? profileName;
  String? price;
  String? createdAt;
  String? updatedAt;

  Labprofile(
      {this.id,
      this.departmentId,
      this.profileName,
      this.price,
      this.createdAt,
      this.updatedAt});

  Labprofile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    profileName = json['profile_name'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department_id'] = departmentId;
    data['profile_name'] = profileName;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
