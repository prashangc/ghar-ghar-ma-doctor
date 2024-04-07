class PostCancelReasonModel {
  String? description;
  int? cancelReason;

  PostCancelReasonModel({this.description, this.cancelReason});

  PostCancelReasonModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    cancelReason = json['cancel_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['cancel_reason'] = cancelReason;
    return data;
  }
}
