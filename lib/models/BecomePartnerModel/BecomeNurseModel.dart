class BecomeNurseModel {
  String? address;
  String? image;
  String? file;
  String? nncNo;
  String? qualification;
  String? yearPracticed;
  String? gender;

  BecomeNurseModel(
      {this.address,
      this.image,
      this.file,
      this.nncNo,
      this.qualification,
      this.yearPracticed,
      this.gender});

  BecomeNurseModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    image = json['image'];
    file = json['file'];
    nncNo = json['nnc_no'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['image'] = image;
    data['file'] = file;
    data['nnc_no'] = nncNo;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['gender'] = gender;
    return data;
  }
}
