class AddScreeningFeedbackModel {
  String? comment;
  int? employeeId;
  int? screeningdateId;

  AddScreeningFeedbackModel(
      {this.comment, this.employeeId, this.screeningdateId});

  AddScreeningFeedbackModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    employeeId = json['employee_id'];
    screeningdateId = json['screeningdate_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['employee_id'] = employeeId;
    data['screeningdate_id'] = screeningdateId;
    return data;
  }
}
