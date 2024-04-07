class PatchNurseProfileModel {
  String? name;
  String? phone;
  String? email;
  String? address;
  String? nncNo;
  String? gender;
  String? fee;
  String? qualification;
  String? yearPracticed;

  PatchNurseProfileModel({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.nncNo,
    this.gender,
    this.fee,
    this.qualification,
    this.yearPracticed,
  });

  PatchNurseProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    nncNo = json['nnc_no'];
    gender = json['gender'];
    fee = json['fee'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['nnc_no'] = nncNo;
    data['gender'] = gender;
    data['fee'] = fee;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    return data;
  }
}
