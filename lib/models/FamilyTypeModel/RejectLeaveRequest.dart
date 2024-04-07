class RejectLeaveRequest {
  String? rejectReason;

  RejectLeaveRequest({this.rejectReason});

  RejectLeaveRequest.fromJson(Map<String, dynamic> json) {
    rejectReason = json['reject_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reject_reason'] = rejectReason;
    return data;
  }
}
