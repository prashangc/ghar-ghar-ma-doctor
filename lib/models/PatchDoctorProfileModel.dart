class PatchDoctorProfileModel {
  String? name;
  String? phone;
  String? email;
  String? address;
  String? nmcNo;
  String? salutation;
  String? gender;
  String? department;
  String? fee;
  String? qualification;
  String? yearPracticed;
  String? specialization;
  String? image;
  List<String>? hospital;

  PatchDoctorProfileModel(
      {this.name,
      this.phone,
      this.email,
      this.address,
      this.nmcNo,
      this.salutation,
      this.gender,
      this.department,
      this.fee,
      this.qualification,
      this.yearPracticed,
      this.image,
      this.hospital,
      this.specialization});

  PatchDoctorProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    nmcNo = json['nmc_no'];
    salutation = json['salutation'];
    gender = json['gender'];
    department = json['department'];
    fee = json['fee'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    image = json['image'];
    hospital = json['hospital'] == null
        ? []
        : List<String>.from(json["hospital"].map((x) => x));
    specialization = json['specialization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['nmc_no'] = nmcNo;
    data['salutation'] = salutation;
    data['gender'] = gender;
    data['department'] = department;
    data['fee'] = fee;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['image'] = image;
    data['hospital'] = hospital;
    data['specialization'] = specialization;
    return data;
  }
}
