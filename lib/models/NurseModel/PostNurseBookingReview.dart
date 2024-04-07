class PostNurseBookingReview {
  int? nurseshiftId;
  String? messages;
  int? status;

  PostNurseBookingReview({this.nurseshiftId, this.messages, this.status});

  PostNurseBookingReview.fromJson(Map<String, dynamic> json) {
    nurseshiftId = json['nurseshift_id'];
    messages = json['messages'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nurseshift_id'] = nurseshiftId;
    data['messages'] = messages;
    data['status'] = status;
    return data;
  }
}
