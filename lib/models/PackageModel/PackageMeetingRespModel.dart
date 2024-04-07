class PackageMeetingRespModel {
  String? meetingUrl;
  int? meetingId;
  String? meetingPassword;

  PackageMeetingRespModel(
      {this.meetingUrl, this.meetingId, this.meetingPassword});

  PackageMeetingRespModel.fromJson(Map<String, dynamic> json) {
    meetingUrl = json['meeting_url'];
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meeting_url'] = meetingUrl;
    data['meeting_id'] = meetingId;
    data['meeting_password'] = meetingPassword;
    return data;
  }
}
