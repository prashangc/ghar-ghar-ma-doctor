class PostChangeCurrentPasswordModel {
  String? currentPassword;
  String? newPassword;

  PostChangeCurrentPasswordModel({this.currentPassword, this.newPassword});

  PostChangeCurrentPasswordModel.fromJson(Map<String, dynamic> json) {
    currentPassword = json['current-password'];
    newPassword = json['new-password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current-password'] = currentPassword;
    data['new-password'] = newPassword;
    return data;
  }
}
