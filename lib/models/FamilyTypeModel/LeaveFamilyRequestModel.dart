class LeaveFamilyRequestModel {
  String? leaveReason;

  LeaveFamilyRequestModel({this.leaveReason});

  LeaveFamilyRequestModel.fromJson(Map<String, dynamic> json) {
    leaveReason = json['leave_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leave_reason'] = leaveReason;
    return data;
  }
}
