class ApproveRequestResponseModel {
  String? message;

  ApproveRequestResponseModel({this.message});

  ApproveRequestResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
