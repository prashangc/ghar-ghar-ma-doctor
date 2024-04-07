class ResgisterModel {
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? isVerified;

  ResgisterModel(
      {this.firstName,
      this.middleName,
      this.email,
      this.lastName,
      this.phone,
      this.password,
      this.isVerified});

  ResgisterModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['is_verified'] = isVerified;
    return data;
  }
}
