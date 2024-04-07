class IndividualMedicalReportModel {
  Service? service;
  List<Report>? report;

  IndividualMedicalReportModel({this.service, this.report});

  IndividualMedicalReportModel.fromJson(Map<String, dynamic> json) {
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    if (json['report'] != null) {
      report = <Report>[];
      json['report'].forEach((v) {
        report!.add(Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (report != null) {
      data['report'] = report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? id;
  String? slug;
  String? serviceName;
  String? description;
  String? price;
  String? image;
  String? imagePath;
  String? testResultType;
  String? createdAt;
  String? updatedAt;

  Service(
      {this.id,
      this.slug,
      this.serviceName,
      this.description,
      this.price,
      this.image,
      this.imagePath,
      this.testResultType,
      this.createdAt,
      this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    serviceName = json['service_name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    imagePath = json['image_path'];
    testResultType = json['test_result_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['service_name'] = serviceName;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['test_result_type'] = testResultType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Report {
  int? id;
  int? memberId;
  int? userpackageId;
  int? screeningId;
  int? serviceId;
  String? createdAt;
  String? updatedAt;
  Screening? screening;
  List<Labreports>? labreports;

  Report(
      {this.id,
      this.memberId,
      this.userpackageId,
      this.screeningId,
      this.serviceId,
      this.createdAt,
      this.updatedAt,
      this.screening,
      this.labreports});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    userpackageId = json['userpackage_id'];
    screeningId = json['screening_id'];
    serviceId = json['service_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    screening = json['screening'] != null
        ? Screening.fromJson(json['screening'])
        : null;
    if (json['labreports'] != null) {
      labreports = <Labreports>[];
      json['labreports'].forEach((v) {
        labreports!.add(Labreports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['userpackage_id'] = userpackageId;
    data['screening_id'] = screeningId;
    data['service_id'] = serviceId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (screening != null) {
      data['screening'] = screening!.toJson();
    }
    if (labreports != null) {
      data['labreports'] = labreports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Screening {
  int? id;
  String? screening;
  String? createdAt;
  String? updatedAt;

  Screening({this.id, this.screening, this.createdAt, this.updatedAt});

  Screening.fromJson(Map<String, dynamic> json) {
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

class Labreports {
  int? id;
  int? reportId;
  int? testId;
  int? minRange;
  int? maxRange;
  num? value;
  String? result;
  String? report;
  String? reportPath;
  String? createdAt;
  String? updatedAt;
  Test? test;

  Labreports(
      {this.id,
      this.reportId,
      this.testId,
      this.minRange,
      this.maxRange,
      this.value,
      this.result,
      this.report,
      this.reportPath,
      this.createdAt,
      this.updatedAt,
      this.test});

  Labreports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportId = json['report_id'];
    testId = json['test_id'];
    minRange = json['min_range'];
    maxRange = json['max_range'];
    value = json['value'];
    result = json['result'];
    report = json['report'];
    reportPath = json['report_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    test = json['test'] != null ? Test.fromJson(json['test']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['report_id'] = reportId;
    data['test_id'] = testId;
    data['min_range'] = minRange;
    data['max_range'] = maxRange;
    data['value'] = value;
    data['result'] = result;
    data['report'] = report;
    data['report_path'] = reportPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (test != null) {
      data['test'] = test!.toJson();
    }
    return data;
  }
}

class Test {
  int? id;
  int? serviceId;
  String? tests;
  String? maleMinRange;
  String? maleMaxRange;
  String? femaleMinRange;
  String? femaleMaxRange;
  String? childMinRange;
  String? childMaxRange;
  String? unit;
  String? createdAt;
  String? updatedAt;

  Test(
      {this.id,
      this.serviceId,
      this.tests,
      this.maleMinRange,
      this.maleMaxRange,
      this.femaleMinRange,
      this.femaleMaxRange,
      this.childMinRange,
      this.childMaxRange,
      this.unit,
      this.createdAt,
      this.updatedAt});

  Test.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    tests = json['tests'];
    maleMinRange = json['male_min_range'];
    maleMaxRange = json['male_max_range'];
    femaleMinRange = json['female_min_range'];
    femaleMaxRange = json['female_max_range'];
    childMinRange = json['child_min_range'];
    childMaxRange = json['child_max_range'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['tests'] = tests;
    data['male_min_range'] = maleMinRange;
    data['male_max_range'] = maleMaxRange;
    data['female_min_range'] = femaleMinRange;
    data['female_max_range'] = femaleMaxRange;
    data['child_min_range'] = childMinRange;
    data['child_max_range'] = childMaxRange;
    data['unit'] = unit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
