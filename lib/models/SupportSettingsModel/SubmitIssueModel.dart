class SubmitIssueModel {
  int? subjectId;
  String? message;

  SubmitIssueModel({this.subjectId, this.message});

  SubmitIssueModel.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['message'] = message;
    return data;
  }
}
