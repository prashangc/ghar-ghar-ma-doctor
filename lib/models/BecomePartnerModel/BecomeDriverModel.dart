class BecomeDriverModel {
  String? address;
  String? image;
  String? file;

  BecomeDriverModel({this.address, this.image, this.file});

  BecomeDriverModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    image = json['image'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['image'] = image;
    data['file'] = file;
    return data;
  }
}
