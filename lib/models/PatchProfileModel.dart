class PatchProfileModel {
  String? name;
  String? phone;
  String? email;
  String? address;
  String? height;
  String? weight;
  String? gender;
  String? dob;
  String? country;
  String? bloodGroup;
  String? familyName;
  String? memberType;
  String? image;
  String? imagePath;
  String? file;
  String? heightFeet;
  String? heightInch;
  String? filePath;

  PatchProfileModel(
      {this.name,
      this.phone,
      this.email,
      this.address,
      this.height,
      this.weight,
      this.country,
      this.gender,
      this.dob,
      this.bloodGroup,
      this.familyName,
      this.heightFeet,
      this.heightInch,
      this.memberType,
      this.image,
      this.imagePath,
      this.file,
      this.filePath});

  PatchProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    country = json['country'];
    address = json['address'];
    height = json['height'];
    weight = json['weight'];
    gender = json['gender'];
    dob = json['dob'];
    heightFeet = json['height_feet'];
    heightInch = json['height_inch'];
    bloodGroup = json['blood_group'];
    image = json['image'];
    imagePath = json['imagePath'];
    file = json['file'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['height_feet'] = heightFeet;
    data['height_inch'] = heightInch;
    data['height'] = height;
    data['weight'] = weight;
    data['gender'] = gender;
    data['dob'] = dob;
    data['country'] = country;
    data['blood_group'] = bloodGroup;
    data['member_type'] = memberType;
    data['family_name'] = familyName;
    data['image'] = image;
    data['imagePath'] = imagePath;
    data['file'] = file;
    data['filePath'] = filePath;
    return data;
  }
}
