class PostReferFriendModel {
  String? firstName;
  String? lastName;
  String? address;
  String? referralEmail;
  int? gdId;
  String? email;

  PostReferFriendModel(
      {this.firstName,
      this.lastName,
      this.address,
      this.referralEmail,
      this.gdId,
      this.email});

  PostReferFriendModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    referralEmail = json['referral_email'];
    gdId = json['gd_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['referral_email'] = referralEmail;
    data['gd_id'] = gdId;
    data['email'] = email;
    return data;
  }
}
