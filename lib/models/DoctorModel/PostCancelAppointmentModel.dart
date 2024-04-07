class PostCancelAppointmentModel {
  String? cancelReason;

  PostCancelAppointmentModel({this.cancelReason});

  PostCancelAppointmentModel.fromJson(Map<String, dynamic> json) {
    cancelReason = json['cancel_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cancel_reason'] = cancelReason;
    return data;
  }
}
