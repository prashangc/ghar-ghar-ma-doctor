class ApproveRequestModel {
  int? id;

  ApproveRequestModel({this.id});

  ApproveRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
