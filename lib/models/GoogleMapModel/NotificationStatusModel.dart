class NotificationStatusModel {
  String? status;
  String? authToken;

  NotificationStatusModel({this.status, this.authToken});

  NotificationStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    authToken = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['jwt'] = authToken;
    return data;
  }
}
