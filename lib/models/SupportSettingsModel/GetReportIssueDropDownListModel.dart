class GetReportIssueDropDownListModel {
  int? id;
  String? subject;
  String? createdAt;
  String? updatedAt;

  GetReportIssueDropDownListModel(
      {this.id, this.subject, this.createdAt, this.updatedAt});

  GetReportIssueDropDownListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
