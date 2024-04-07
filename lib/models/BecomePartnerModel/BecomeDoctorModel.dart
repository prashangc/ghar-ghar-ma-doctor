class BecomeDoctorModel {
  String? address;
  String? image;
  String? file;
  String? nmcNo;
  String? salutation;
  String? qualification;
  String? yearPracticed;
  String? specialization;
  String? gender;
  int? department;

  BecomeDoctorModel(
      {this.address,
      this.image,
      this.file,
      this.nmcNo,
      this.salutation,
      this.qualification,
      this.yearPracticed,
      this.specialization,
      this.gender,
      this.department});

  BecomeDoctorModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    image = json['image'];
    file = json['file'];
    nmcNo = json['nmc_no'];
    salutation = json['salutation'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    specialization = json['specialization'];
    gender = json['gender'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['image'] = image;
    data['file'] = file;
    data['nmc_no'] = nmcNo;
    data['salutation'] = salutation;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['specialization'] = specialization;
    data['gender'] = gender;
    data['department'] = department;
    return data;
  }
}
