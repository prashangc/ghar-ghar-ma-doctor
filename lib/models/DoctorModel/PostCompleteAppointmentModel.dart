class PostCompleteAppointmentModel {
  String? history;
  String? examination;
  String? treatment;
  String? progress;
  String? followUpDate;
  String? image;

  PostCompleteAppointmentModel(
      {this.history,
      this.examination,
      this.treatment,
      this.progress,
      this.followUpDate,
      this.image});

  PostCompleteAppointmentModel.fromJson(Map<String, dynamic> json) {
    history = json['history'];
    examination = json['examination'];
    treatment = json['treatment'];
    progress = json['progress'];
    followUpDate = json['followUpDate'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['history'] = history;
    data['examination'] = examination;
    data['treatment'] = treatment;
    data['progress'] = progress;
    data['followUpDate'] = followUpDate;
    data['image'] = image;
    return data;
  }
}
