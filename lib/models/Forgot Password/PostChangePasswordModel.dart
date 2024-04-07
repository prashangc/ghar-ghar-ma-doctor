class PostChangePasswordModel {
  String? email;
  String? code;
  String? password;
  String? passwordConfirmation;

  PostChangePasswordModel(
      {this.email, this.code, this.password, this.passwordConfirmation});

  PostChangePasswordModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    code = json['code'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['code'] = code;
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    return data;
  }
}
