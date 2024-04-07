class PatchVendorProfileModel {
  String? name;
  String? email;
  String? phone;
  String? address;
  String? image;

  PatchVendorProfileModel(
      {this.name, this.email, this.phone, this.address, this.image});

  PatchVendorProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['image'] = image;
    return data;
  }
}
