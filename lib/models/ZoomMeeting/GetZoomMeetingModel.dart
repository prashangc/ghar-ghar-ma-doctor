class GetZoomMeetingModel {
  int? id;
  String? topic;
  String? startTime;
  String? agenda;
  int? userId;
  String? joinUrl;
  String? startUrl;
  int? meetingId;
  String? meetingPassword;
  int? status;
  String? createdAt;
  String? updatedAt;

  GetZoomMeetingModel(
      {this.id,
      this.topic,
      this.startTime,
      this.agenda,
      this.userId,
      this.joinUrl,
      this.startUrl,
      this.meetingId,
      this.meetingPassword,
      this.status,
      this.createdAt,
      this.updatedAt});

  GetZoomMeetingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    startTime = json['start_time'];
    agenda = json['agenda'];
    userId = json['user_id'];
    joinUrl = json['join_url'];
    startUrl = json['start_url'];
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['topic'] = topic;
    data['start_time'] = startTime;
    data['agenda'] = agenda;
    data['user_id'] = userId;
    data['join_url'] = joinUrl;
    data['start_url'] = startUrl;
    data['meeting_id'] = meetingId;
    data['meeting_password'] = meetingPassword;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
