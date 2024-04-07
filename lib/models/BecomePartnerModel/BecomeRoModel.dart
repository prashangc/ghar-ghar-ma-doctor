class BecomeRoModel {
  String? address;
  String? image;
  String? file;
  String? marketing;
  String? gender;

  BecomeRoModel(
      {this.address, this.image, this.file, this.marketing, this.gender});

  BecomeRoModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    image = json['image'];
    file = json['file'];
    marketing = json['marketing_supervisor_id'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['image'] = image;
    data['file'] = file;
    data['marketing_supervisor_id'] = marketing;
    data['gender'] = gender;
    return data;
  }
}
