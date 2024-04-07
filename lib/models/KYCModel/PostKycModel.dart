class PostKycModel {
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? birthDate;
  String? citizenshipDate;
  String? citizenshipNo;
  String? citizenshipIssueDistrict;
  String? nationality;
  String? mobileNumber;
  String? email;
  String? country;
  int? provinceId;
  int? districtId;
  int? municipalityId;
  int? wardId;
  String? fatherFullName;
  String? motherFullName;
  String? grandfatherFullName;
  String? husbandWifeFullName;
  String? latitude;
  String? longitude;
  String? front;
  String? back;
  PostKycModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.citizenshipDate,
    this.citizenshipNo,
    this.citizenshipIssueDistrict,
    this.nationality,
    this.mobileNumber,
    this.email,
    this.country,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.wardId,
    this.fatherFullName,
    this.motherFullName,
    this.grandfatherFullName,
    this.husbandWifeFullName,
    this.latitude,
    this.longitude,
    this.front,
    this.back,
  });

  PostKycModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    citizenshipDate = json['citizenship_date'];
    citizenshipNo = json['citizenship_no'];
    citizenshipIssueDistrict = json['citizenship_issue_district'];
    nationality = json['nationality'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    country = json['country'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    municipalityId = json['municipality_id'];
    wardId = json['ward_id'];
    fatherFullName = json['father_full_name'];
    motherFullName = json['mother_full_name'];
    grandfatherFullName = json['grandfather_full_name'];
    husbandWifeFullName = json['husband_wife_full_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    front = json['citizenship_front'];
    back = json['citizenship_back'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['birth_date'] = birthDate;
    data['citizenship_date'] = citizenshipDate;
    data['citizenship_no'] = citizenshipNo;
    data['citizenship_issue_district'] = citizenshipIssueDistrict;
    data['nationality'] = nationality;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['country'] = country;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['municipality_id'] = municipalityId;
    data['ward_id'] = wardId;
    data['father_full_name'] = fatherFullName;
    data['mother_full_name'] = motherFullName;
    data['grandfather_full_name'] = grandfatherFullName;
    data['husband_wife_full_name'] = husbandWifeFullName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['citizenship_front'] = front;
    data['citizenship_back'] = back;
    return data;
  }
}
