class GetCancelReasonModel {
  int? id;
  String? cancelReason;
  String? createdAt;
  String? updatedAt;

  GetCancelReasonModel(
      {this.id, this.cancelReason, this.createdAt, this.updatedAt});

  GetCancelReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cancelReason = json['cancel_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cancel_reason'] = cancelReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
