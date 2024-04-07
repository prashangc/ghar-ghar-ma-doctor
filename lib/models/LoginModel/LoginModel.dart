class LoginModel {
  String? email;
  String? password;
  String? uniqueId;
  String? platform;

  LoginModel({this.email, this.password, this.platform, this.uniqueId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    email = json['login'];
    password = json['password'];
    platform = json['platform'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = email;
    data['password'] = password;
    data['platform'] = platform;
    data['unique_id'] = uniqueId;
    return data;
  }
}
