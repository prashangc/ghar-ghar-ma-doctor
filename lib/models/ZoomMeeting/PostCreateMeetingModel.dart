class PostCreateMeetingModel {
  String? topic;
  String? startTime;
  String? agenda;

  PostCreateMeetingModel({this.topic, this.startTime, this.agenda});

  PostCreateMeetingModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    startTime = json['start_time'];
    agenda = json['agenda'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic'] = topic;
    data['start_time'] = startTime;
    data['agenda'] = agenda;
    return data;
  }
}
